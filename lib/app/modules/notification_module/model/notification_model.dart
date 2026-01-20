class NotificationItem {
  final String id;
  final String type;
  final NotificationData data;
  final DateTime? readAt;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.type,
    required this.data,
    this.readAt,
    required this.createdAt,
  });

  bool get isRead => readAt != null;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      data: NotificationData.fromJson(json['data'] ?? {}),
      readAt:
          json['read_at'] != null ? DateTime.tryParse(json['read_at']) : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class NotificationData {
  final String type;
  final String group;
  final String priority;
  final bool requiresAttention;
  final String title;
  final String message;
  final String? device;
  final String? ip;
  final List<NotificationAction> actions;

  NotificationData({
    required this.type,
    required this.group,
    required this.priority,
    required this.requiresAttention,
    required this.title,
    required this.message,
    this.device,
    this.ip,
    required this.actions,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      type: json['type'] ?? '',
      group: json['group'] ?? '',
      priority: json['priority'] ?? 'normal',
      requiresAttention: json['requires_attention'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      device: json['device'],
      ip: json['ip'],
      actions: (json['actions'] as List<dynamic>?)
              ?.map((a) => NotificationAction.fromJson(a))
              .toList() ??
          [],
    );
  }
}

class NotificationAction {
  final String title;
  final String action;

  NotificationAction({required this.title, required this.action});

  factory NotificationAction.fromJson(Map<String, dynamic> json) {
    return NotificationAction(
      title: json['title'] ?? '',
      action: json['action'] ?? '',
    );
  }
}
