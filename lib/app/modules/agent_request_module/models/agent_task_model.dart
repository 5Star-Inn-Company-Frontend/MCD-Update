class AgentTaskModel {
  final int id;
  final String type;
  final int level;
  final String description;
  final int current;
  final int goal;
  final int defaultValue;
  final int completed;
  final String userName;
  final String createdAt;
  final String updatedAt;

  AgentTaskModel({
    required this.id,
    required this.type,
    required this.level,
    required this.description,
    required this.current,
    required this.goal,
    required this.defaultValue,
    required this.completed,
    required this.userName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AgentTaskModel.fromJson(Map<String, dynamic> json) {
    return AgentTaskModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      level: json['level'] ?? 0,
      description: json['description'] ?? '',
      current: json['current'] ?? 0,
      goal: json['goal'] ?? 0,
      defaultValue: json['default'] ?? 0,
      completed: json['completed'] ?? 0,
      userName: json['user_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'level': level,
      'description': description,
      'current': current,
      'goal': goal,
      'default': defaultValue,
      'completed': completed,
      'user_name': userName,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Get progress percentage
  double get progressPercentage {
    if (goal == 0) return 0.0;
    return (current / goal).clamp(0.0, 1.0);
  }

  // Get progress text
  String get progressText {
    return '$current of $goal';
  }

  // Check if task is completed
  bool get isCompleted {
    return completed == 1 || current >= goal;
  }

  // Get icon based on task type
  String get typeIcon {
    switch (type.toLowerCase()) {
      case 'airtime':
        return 'phone_android';
      case 'data':
        return 'shopping_bag';
      case 'refer':
        return 'people';
      case 'tv':
        return 'tv';
      default:
        return 'task';
    }
  }

  // Get type display name
  String get typeDisplayName {
    switch (type.toLowerCase()) {
      case 'airtime':
        return 'Airtime';
      case 'data':
        return 'Data';
      case 'refer':
        return 'Referral';
      case 'tv':
        return 'TV Subscription';
      default:
        return type;
    }
  }
}

class AgentTasksResponse {
  final int success;
  final String message;
  final String lastUpdated;
  final int daysLeft;
  final List<AgentTaskModel> tasks;

  AgentTasksResponse({
    required this.success,
    required this.message,
    required this.lastUpdated,
    required this.daysLeft,
    required this.tasks,
  });

  factory AgentTasksResponse.fromJson(Map<String, dynamic> json) {
    return AgentTasksResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      lastUpdated: json['last_updated'] ?? '',
      daysLeft: json['days_left'] ?? 0,
      tasks: (json['data'] as List<dynamic>?)
              ?.map((task) => AgentTaskModel.fromJson(task))
              .toList() ??
          [],
    );
  }

  // Get completed tasks count
  int get completedTasksCount {
    return tasks.where((task) => task.isCompleted).length;
  }

  // Get total tasks count
  int get totalTasksCount {
    return tasks.length;
  }

  // Get overall progress percentage
  double get overallProgressPercentage {
    if (totalTasksCount == 0) return 0.0;
    return (completedTasksCount / totalTasksCount).clamp(0.0, 1.0);
  }
}

class AgentPreviousTasksResponse {
  final int success;
  final String message;
  final String date;
  final List<AgentTaskModel> tasks;

  AgentPreviousTasksResponse({
    required this.success,
    required this.message,
    required this.date,
    required this.tasks,
  });

  factory AgentPreviousTasksResponse.fromJson(Map<String, dynamic> json) {
    return AgentPreviousTasksResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      tasks: (json['data'] as List<dynamic>?)
              ?.map((task) => AgentTaskModel.fromJson(task))
              .toList() ??
          [],
    );
  }
}
