class AirtimeProvider {
  final String network;
  final String discount;
  final int status;
  final String server;

  AirtimeProvider({
    required this.network,
    required this.discount,
    required this.status,
    required this.server,
  });

  factory AirtimeProvider.fromJson(Map<String, dynamic> json) {
    return AirtimeProvider(
      network: json['network'] ?? '',
      discount: json['discount']?.toString() ?? '0',
      status: json['status'] ?? 0,
      server: json['server']?.toString() ?? '',
    );
  }
}