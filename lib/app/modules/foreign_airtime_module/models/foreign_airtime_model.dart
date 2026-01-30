import 'dart:convert';

class CountryModel {
  final String name;
  final String code;
  final String flag;
  final String currency;
  final List<String> callingCodes;

  CountryModel({
    required this.name,
    required this.code,
    required this.flag,
    required this.currency,
    this.callingCodes = const [],
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    // Parse callingCodes which might be a string or a list
    List<String> codes = [];
    if (json['callingCodes'] != null) {
      if (json['callingCodes'] is List) {
        codes = List<String>.from(json['callingCodes']);
      } else if (json['callingCodes'] is String) {
        // Parse the string as JSON array
        try {
          final decoded = jsonDecode(json['callingCodes']);
          if (decoded is List) {
            codes = List<String>.from(decoded);
          }
        } catch (e) {
          // If parsing fails, treat as single value
          codes = [json['callingCodes']];
        }
      }
    }

    return CountryModel(
      name: json['name'] ?? '',
      code: json['isoName'] ?? json['code'] ?? '',
      flag: json['flag'] ?? '',
      currency: json['currencyCode'] ?? json['currency'] ?? '',
      callingCodes: codes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'flag': flag,
      'currency': currency,
      'callingCodes': callingCodes,
    };
  }
}

class CountriesResponse {
  final int success;
  final String message;
  final List<CountryModel> countries;

  CountriesResponse({
    required this.success,
    required this.message,
    required this.countries,
  });

  factory CountriesResponse.fromJson(Map<String, dynamic> json) {
    return CountriesResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      countries: (json['data'] as List<dynamic>?)
              ?.map((country) =>
                  CountryModel.fromJson(country as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get isSuccess => success == 1;
}

class ForeignNetworkModel {
  final int id;
  final String name;
  final String code;
  final String country;
  final String logo;

  ForeignNetworkModel({
    required this.id,
    required this.name,
    required this.code,
    required this.country,
    required this.logo,
  });

  factory ForeignNetworkModel.fromJson(Map<String, dynamic> json) {
    return ForeignNetworkModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      country: json['country'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'country': country,
      'logo': logo,
    };
  }
}

class ForeignNetworksResponse {
  final int success;
  final String message;
  final List<ForeignNetworkModel> networks;

  ForeignNetworksResponse({
    required this.success,
    required this.message,
    required this.networks,
  });

  factory ForeignNetworksResponse.fromJson(Map<String, dynamic> json) {
    return ForeignNetworksResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      networks: (json['data'] as List<dynamic>?)
              ?.map((network) =>
                  ForeignNetworkModel.fromJson(network as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get isSuccess => success == 1;
}
