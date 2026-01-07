class PosTerminalModel {
  final int id;
  final String name;
  final String outright;
  final String lease;
  final String installment;
  final String installmentInitial;
  final String repayment;
  final int frequency;
  final String image;
  final int status;
  final String provider;
  final String createdAt;
  final String updatedAt;

  PosTerminalModel({
    required this.id,
    required this.name,
    required this.outright,
    required this.lease,
    required this.installment,
    required this.installmentInitial,
    required this.repayment,
    required this.frequency,
    required this.image,
    required this.status,
    required this.provider,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PosTerminalModel.fromJson(Map<String, dynamic> json) {
    return PosTerminalModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      outright: json['outright'] ?? '0',
      lease: json['lease'] ?? '0',
      installment: json['installment'] ?? '0',
      installmentInitial: json['installment_initial'] ?? '0',
      repayment: json['repayment'] ?? '0',
      frequency: json['frequency'] ?? 0,
      image: json['image'] ?? '',
      status: json['status'] ?? 0,
      provider: json['provider'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'outright': outright,
      'lease': lease,
      'installment': installment,
      'installment_initial': installmentInitial,
      'repayment': repayment,
      'frequency': frequency,
      'image': image,
      'status': status,
      'provider': provider,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String get frequencyText {
    switch (frequency) {
      case 1:
        return 'Daily';
      case 7:
        return 'Weekly';
      case 30:
        return 'Monthly';
      default:
        return '$frequency days';
    }
  }

  String get formattedOutright => _formatAmount(outright);
  String get formattedLease => _formatAmount(lease);
  String get formattedInstallment => _formatAmount(installment);
  String get formattedInstallmentInitial => _formatAmount(installmentInitial);
  String get formattedRepayment => _formatAmount(repayment);

  String _formatAmount(String amount) {
    try {
      final value = double.parse(amount);
      if (value == 0) return '0';
      return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    } catch (e) {
      return amount;
    }
  }
}
