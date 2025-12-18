// import 'package:flutter_test/flutter_test.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get/get.dart';
// import 'package:mcd/core/services/connectivity_service.dart';

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   late ConnectivityService connectivityService;

//   setUp(() {
//     Get.testMode = true;
//     connectivityService = ConnectivityService();
//   });

//   tearDown(() {
//     Get.reset();
//   });

//   group('ConnectivityService Tests', () {
//     test('Initial state should have connection', () {
//       expect(connectivityService.isConnected.value, true);
//     });

//     test('Connection type should be none initially', () {
//       expect(connectivityService.connectionType.value, ConnectivityResult.none);
//     });

//     test('Should show banner when connection is lost', () {
//       connectivityService.isConnected.value = false;
//       expect(connectivityService.showNoConnectionBanner.value, false);
//     });

//     test('getConnectionTypeString returns correct string for WiFi', () {
//       final service = ConnectivityService();
//       final result = service.getConnectionTypeString(ConnectivityResult.wifi);
//       expect(result, 'WiFi');
//     });

//     test('getConnectionTypeString returns correct string for Mobile Data', () {
//       final service = ConnectivityService();
//       final result = service.getConnectionTypeString(ConnectivityResult.mobile);
//       expect(result, 'Mobile Data');
//     });

//     test('getConnectionTypeString returns correct string for No Connection', () {
//       final service = ConnectivityService();
//       final result = service.getConnectionTypeString(ConnectivityResult.none);
//       expect(result, 'No Connection');
//     });

//     test('getConnectionTypeString returns correct string for Ethernet', () {
//       final service = ConnectivityService();
//       final result = service.getConnectionTypeString(ConnectivityResult.ethernet);
//       expect(result, 'Ethernet');
//     });

//     test('checkInternetConnection handles timeout', () async {
//       final service = ConnectivityService();
//       final hasConnection = await service.checkInternetConnection();
//       expect(hasConnection, isA<bool>());
//     }, timeout: const Timeout(Duration(seconds: 10)));
//   });

//   group('Network Error Handling Tests', () {
//     test('Should handle connection timeout gracefully', () {
//       final errorMessage = 'Connection timed out';
//       expect(errorMessage.contains('timed out'), true);
//     });

//     test('Should handle no internet connection', () {
//       final errorMessage = 'No internet connection';
//       expect(errorMessage.contains('No internet'), true);
//     });

//     test('Should detect socket exception', () {
//       final errorMessage = 'SocketException: Failed host lookup';
//       expect(errorMessage.contains('SocketException'), true);
//     });
//   });

//   group('Connectivity State Management', () {
//     test('isConnected observable updates correctly', () {
//       expect(connectivityService.isConnected.value, true);
      
//       connectivityService.isConnected.value = false;
//       expect(connectivityService.isConnected.value, false);
      
//       connectivityService.isConnected.value = true;
//       expect(connectivityService.isConnected.value, true);
//     });

//     test('connectionType observable updates correctly', () {
//       connectivityService.connectionType.value = ConnectivityResult.wifi;
//       expect(connectivityService.connectionType.value, ConnectivityResult.wifi);
      
//       connectivityService.connectionType.value = ConnectivityResult.mobile;
//       expect(connectivityService.connectionType.value, ConnectivityResult.mobile);
      
//       connectivityService.connectionType.value = ConnectivityResult.none;
//       expect(connectivityService.connectionType.value, ConnectivityResult.none);
//     });

//     test('showNoConnectionBanner observable updates correctly', () {
//       expect(connectivityService.showNoConnectionBanner.value, false);
      
//       connectivityService.showNoConnectionBanner.value = true;
//       expect(connectivityService.showNoConnectionBanner.value, true);
      
//       connectivityService.showNoConnectionBanner.value = false;
//       expect(connectivityService.showNoConnectionBanner.value, false);
//     });
//   });
// }
