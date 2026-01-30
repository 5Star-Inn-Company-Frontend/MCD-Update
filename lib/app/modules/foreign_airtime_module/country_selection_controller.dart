import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/foreign_airtime_module/models/foreign_airtime_model.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class CountrySelectionController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  // Observables
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final countries = <CountryModel>[].obs;
  final selectedCountry = Rxn<CountryModel>();
  final searchQuery = ''.obs;

  // Filtered countries based on search
  List<CountryModel> get filteredCountries {
    if (searchQuery.value.isEmpty) {
      return countries;
    }
    return countries
        .where((country) =>
            country.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    dev.log('CountrySelectionController initialized', name: 'ForeignAirtime');
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      dev.log('Fetching countries list...', name: 'ForeignAirtime');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null || transactionUrl.isEmpty) {
        errorMessage.value = 'Service URL not configured. Please login again.';
        isLoading.value = false;
        return;
      }

      final url = '${transactionUrl}airtime/countries';
      dev.log('Fetching from: $url', name: 'ForeignAirtime');

      final result = await apiService.getrequest(url);

      result.fold(
        (failure) {
          dev.log('Failed to fetch countries',
              name: 'ForeignAirtime', error: failure.message);
          errorMessage.value = failure.message;
          isLoading.value = false;
        },
        (data) {
          dev.log('Countries response: $data', name: 'ForeignAirtime');

          if (data['success'] == 1) {
            final response = CountriesResponse.fromJson(data);
            countries.value = response.countries;
            dev.log('Fetched ${countries.length} countries',
                name: 'ForeignAirtime');
          } else {
            errorMessage.value = data['message'] ?? 'Failed to fetch countries';
          }

          isLoading.value = false;
        },
      );
    } catch (e) {
      dev.log('Error fetching countries', name: 'ForeignAirtime', error: e);
      errorMessage.value = 'An error occurred while fetching countries';
      isLoading.value = false;
    }
  }

  void selectCountry(CountryModel country) {
    dev.log('Country selected: ${country.name} (${country.code})',
        name: 'ForeignAirtime');
    selectedCountry.value = country;

    // Get the first calling code or empty string
    final callingCode = country.callingCodes.isNotEmpty 
        ? country.callingCodes.first 
        : '';

    // Navigate to number verification with country code
    Get.toNamed(
      Routes.NUMBER_VERIFICATION_MODULE,
      arguments: {
        'redirectTo': Routes.AIRTIME_MODULE,
        'isForeign': true,
        'countryCode': country.code,
        'countryName': country.name,
        'callingCode': callingCode,
      },
    );
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
