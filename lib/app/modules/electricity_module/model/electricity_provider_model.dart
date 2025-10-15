class ElectricityProvider {
  final int id;
  final String name;
  final String code;

  ElectricityProvider({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ElectricityProvider.fromJson(Map<String, dynamic> json) {
    return ElectricityProvider(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}