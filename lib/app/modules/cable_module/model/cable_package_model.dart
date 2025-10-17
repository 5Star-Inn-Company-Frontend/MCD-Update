class CablePackage {
  final int id;
  final String name;
  final String code;
  final String amount;
  final String duration;

  CablePackage({
    required this.id,
    required this.name,
    required this.code,
    required this.amount,
    required this.duration,
  });

  factory CablePackage.fromJson(Map<String, dynamic> json) {
    return CablePackage(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? json['coded'] ?? '', // Support both 'code' and 'coded'
      amount: json['amount']?.toString() ?? '0',
      duration: json['duration']?.toString() ?? '1',
    );
  }
}