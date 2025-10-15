class BettingProvider {
  final int id;
  final String name;
  final String code;
  final String discount;

  BettingProvider({
    required this.id,
    required this.name,
    required this.code,
    required this.discount,
  });

  factory BettingProvider.fromJson(Map<String, dynamic> json) {
    return BettingProvider(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      discount: json['discount']?.toString() ?? '0',
    );
  }
}