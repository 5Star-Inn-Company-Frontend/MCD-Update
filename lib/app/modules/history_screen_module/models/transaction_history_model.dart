class TransactionHistoryModel {
  final int success;
  final String message;
  final List<Transaction> transactions;
  final double totalIn;
  final double totalOut;

  TransactionHistoryModel({
    required this.success,
    required this.message,
    required this.transactions,
    required this.totalIn,
    required this.totalOut,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure from API
    final data = json['data'];
    final transactionsList = data is Map<String, dynamic> 
        ? (data['data'] as List?) 
        : (json['transactions'] as List?);
    
    return TransactionHistoryModel(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      transactions: transactionsList
              ?.map((transaction) => Transaction.fromJson(transaction))
              .toList() ??
          [],
      totalIn: _parseDouble(json['total_in'] ?? json['totalIn'] ?? 0),
      totalOut: _parseDouble(json['total_out'] ?? json['totalOut'] ?? 0),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'total_in': totalIn,
      'total_out': totalOut,
    };
  }
}

class Transaction {
  final String id;
  final String type;
  final String description;
  final dynamic amount;
  final String status;
  final String date;
  final String? reference;
  final String? recipient;
  final String? sender;
  final Map<String, dynamic>? metadata;

  Transaction({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.status,
    required this.date,
    this.reference,
    this.recipient,
    this.sender,
    this.metadata,
  });

  // Get amount as double
  double get amountValue {
    if (amount is double) return amount;
    if (amount is int) return amount.toDouble();
    if (amount is String) return double.tryParse(amount) ?? 0.0;
    return 0.0;
  }

  // Check if transaction is credit (money in)
  bool get isCredit {
    // Check based on transaction code, type, or description
    final typeLower = type.toLowerCase();
    final descLower = description.toLowerCase();
    
    return typeLower.contains('commission') ||
        typeLower.contains('reversal') ||
        typeLower.contains('credit') ||
        typeLower.contains('received') ||
        descLower.contains('reversal') ||
        descLower.contains('commission') ||
        status.toLowerCase().contains('credit');
  }

  // Get formatted date and time
  String get formattedTime {
    try {
      final dateTime = DateTime.parse(date);
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final period = dateTime.hour >= 12 ? 'pm' : 'am';
      return '${hour}:${dateTime.minute.toString().padLeft(2, '0')}$period';
    } catch (e) {
      return date;
    }
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id']?.toString() ?? '',
      type: json['name'] ?? json['type'] ?? json['transaction_type'] ?? '',
      description: json['description'] ?? json['narration'] ?? '',
      amount: json['amount'] ?? 0,
      status: json['status'] ?? '',
      date: json['date'] ?? json['created_at'] ?? json['timestamp'] ?? '',
      reference: json['ref'] ?? json['reference'],
      recipient: json['recipient'],
      sender: json['user_name'] ?? json['sender'],
      metadata: json['server_log'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'amount': amount,
      'status': status,
      'date': date,
      'reference': reference,
      'recipient': recipient,
      'sender': sender,
      'metadata': metadata,
    };
  }
}
