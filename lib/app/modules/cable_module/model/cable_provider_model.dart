class CableProvider {
  final int id;
  final String name;
  final String code;

  CableProvider({required this.id, required this.name, required this.code});

  factory CableProvider.fromJson(Map<String, dynamic> json) {
    return CableProvider(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}