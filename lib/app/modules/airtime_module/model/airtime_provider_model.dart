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
      network: json['network'] ?? json['name'] ?? '',
      discount: json['discount']?.toString() ?? json['commission']?.toString() ?? '0',
      status: _parseInt(json['status'] ?? 1),
      server: json['server']?.toString() ?? json['operatorId']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}