class GameModel {
  final int id;
  final String name;
  final String logo;
  final String url;
  final int status;
  final String createdAt;
  final String updatedAt;

  GameModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.url,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      url: json['url'] ?? '',
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'url': url,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  bool get isActive => status == 1;
}

class GamesResponse {
  final int success;
  final String message;
  final List<GameModel> games;

  GamesResponse({
    required this.success,
    required this.message,
    required this.games,
  });

  factory GamesResponse.fromJson(Map<String, dynamic> json) {
    return GamesResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      games: (json['data'] as List<dynamic>?)
              ?.map((game) => GameModel.fromJson(game as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get isSuccess => success == 1;
}
