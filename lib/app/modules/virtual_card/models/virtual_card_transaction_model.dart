class VirtualCardTransactionModel {
  final int id;
  final String type;
  final String description;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;

  VirtualCardTransactionModel({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
  });

  factory VirtualCardTransactionModel.fromJson(Map<String, dynamic> json) {
    return VirtualCardTransactionModel(
      id: json['id'] ?? 0,
      type: json['type']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      currency: json['currency']?.toString() ?? 'USD',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class VirtualCardTransactionListResponse {
  final int success;
  final String message;
  final List<VirtualCardTransactionModel> transactions;

  VirtualCardTransactionListResponse({
    required this.success,
    required this.message,
    required this.transactions,
  });

  factory VirtualCardTransactionListResponse.fromJson(Map<String, dynamic> json) {
    List<VirtualCardTransactionModel> transactionList = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        transactionList = (json['data'] as List)
            .map((transaction) => VirtualCardTransactionModel.fromJson(transaction))
            .toList();
      }
    }

    return VirtualCardTransactionListResponse(
      success: json['success'] ?? 0,
      message: json['message']?.toString() ?? '',
      transactions: transactionList,
    );
  }
}
