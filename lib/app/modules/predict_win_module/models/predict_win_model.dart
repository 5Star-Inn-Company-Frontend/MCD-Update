class PredictWinModel {
  final int id;
  final String matchTitle;
  final String team1;
  final String team2;
  final String team1Flag;
  final String team2Flag;
  final String matchDate;
  final String kickoffTime;
  final String location;
  final String description;
  final String predictionQuestion;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String? countdown;

  PredictWinModel({
    required this.id,
    required this.matchTitle,
    required this.team1,
    required this.team2,
    required this.team1Flag,
    required this.team2Flag,
    required this.matchDate,
    required this.kickoffTime,
    required this.location,
    required this.description,
    required this.predictionQuestion,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.countdown,
  });

  factory PredictWinModel.fromJson(Map<String, dynamic> json) {
    return PredictWinModel(
      id: json['id'] ?? 0,
      matchTitle: json['match_title'] ?? '',
      team1: json['team1'] ?? '',
      team2: json['team2'] ?? '',
      team1Flag: json['team1_flag'] ?? '',
      team2Flag: json['team2_flag'] ?? '',
      matchDate: json['match_date'] ?? '',
      kickoffTime: json['kickoff_time'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      predictionQuestion: json['prediction_question'] ?? '',
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      countdown: json['countdown'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_title': matchTitle,
      'team1': team1,
      'team2': team2,
      'team1_flag': team1Flag,
      'team2_flag': team2Flag,
      'match_date': matchDate,
      'kickoff_time': kickoffTime,
      'location': location,
      'description': description,
      'prediction_question': predictionQuestion,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'countdown': countdown,
    };
  }

  bool get isActive => status == 1;
}

class PredictWinResponse {
  final int success;
  final String message;
  final List<PredictWinModel> predictions;

  PredictWinResponse({
    required this.success,
    required this.message,
    required this.predictions,
  });

  factory PredictWinResponse.fromJson(Map<String, dynamic> json) {
    return PredictWinResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      predictions: (json['data'] as List<dynamic>?)
              ?.map((prediction) =>
                  PredictWinModel.fromJson(prediction as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get isSuccess => success == 1;
}

class SubmitPredictionRequest {
  final int id;
  final int ques;
  final String answer;
  final String recipient;

  SubmitPredictionRequest({
    required this.id,
    required this.ques,
    required this.answer,
    required this.recipient,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ques': ques,
      'answer': answer,
      'recipient': recipient,
    };
  }
}

class SubmitPredictionResponse {
  final int success;
  final String message;
  final dynamic data;

  SubmitPredictionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SubmitPredictionResponse.fromJson(Map<String, dynamic> json) {
    return SubmitPredictionResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  bool get isSuccess => success == 1;
}
