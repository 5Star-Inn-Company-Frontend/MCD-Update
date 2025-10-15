class NetworkProvider {
  final String name;
  final String imageAsset;

  NetworkProvider({required this.name, required this.imageAsset});

  static List<NetworkProvider> all = [
    NetworkProvider(name: 'MTN', imageAsset: 'assets/images/mtn.png'),
    NetworkProvider(name: 'Airtel', imageAsset: 'assets/images/airtel.png'),
    NetworkProvider(name: 'Glo', imageAsset: 'assets/images/glo.png'),
    NetworkProvider(name: '9mobile', imageAsset: 'assets/images/etisalat.png'),
  ];
}