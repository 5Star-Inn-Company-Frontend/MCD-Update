class VirtualCardModel {
  final int id;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  final String currency;
  final double balance;
  final String brand;
  final String status;
  final DateTime createdAt;

  VirtualCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    required this.currency,
    required this.balance,
    required this.brand,
    required this.status,
    required this.createdAt,
  });

  factory VirtualCardModel.fromJson(Map<String, dynamic> json) {
    return VirtualCardModel(
      id: json['id'] ?? 0,
      cardNumber: json['card_number']?.toString() ?? '',
      cardHolder: json['card_holder']?.toString() ?? '',
      expiryDate: json['expiry_date']?.toString() ?? '',
      cvv: json['cvv']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'USD',
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
      brand: json['brand']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_number': cardNumber,
      'card_holder': cardHolder,
      'expiry_date': expiryDate,
      'cvv': cvv,
      'currency': currency,
      'balance': balance,
      'brand': brand,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class VirtualCardListResponse {
  final int success;
  final String message;
  final List<VirtualCardModel> cards;

  VirtualCardListResponse({
    required this.success,
    required this.message,
    required this.cards,
  });

  factory VirtualCardListResponse.fromJson(Map<String, dynamic> json) {
    List<VirtualCardModel> cardList = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        cardList = (json['data'] as List)
            .map((card) => VirtualCardModel.fromJson(card))
            .toList();
      }
    }

    return VirtualCardListResponse(
      success: json['success'] ?? 0,
      message: json['message']?.toString() ?? '',
      cards: cardList,
    );
  }
}
