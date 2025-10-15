class CablePackage {
  final int id;
  final String name;
  final String price;
  final String code;

  CablePackage({
    required this.id,
    required this.name,
    required this.price,
    required this.code,
  });

  factory CablePackage.fromJson(Map<String, dynamic> json) {
    return CablePackage(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price']?.toString() ?? '0',
      code: json['code'] ?? '',
    );
  }
}