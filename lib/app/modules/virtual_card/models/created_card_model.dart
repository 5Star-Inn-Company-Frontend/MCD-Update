// model for /virtual-card/create api response
class CreatedCardModel {
  final String userName;
  final String customerId;
  final String cardId;
  final String cardType;
  final String brand;
  final String name;
  final String number;
  final String masked;
  final String ccv;
  final String expiry;
  final String address;
  final String currency;
  final int id;

  CreatedCardModel({
    required this.userName,
    required this.customerId,
    required this.cardId,
    required this.cardType,
    required this.brand,
    required this.name,
    required this.number,
    required this.masked,
    required this.ccv,
    required this.expiry,
    required this.address,
    required this.currency,
    required this.id,
  });

  factory CreatedCardModel.fromJson(Map<String, dynamic> json) {
    return CreatedCardModel(
      userName: json['user_name']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      cardId: json['card_id']?.toString() ?? '',
      cardType: json['card_type']?.toString() ?? 'virtual',
      brand: json['brand']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      number: json['number']?.toString() ?? '',
      masked: json['masked']?.toString() ?? '',
      ccv: json['ccv']?.toString() ?? '',
      expiry: json['expiry']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'USD',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'customer_id': customerId,
      'card_id': cardId,
      'card_type': cardType,
      'brand': brand,
      'name': name,
      'number': number,
      'masked': masked,
      'ccv': ccv,
      'expiry': expiry,
      'address': address,
      'currency': currency,
      'id': id,
    };
  }

  // get currency symbol based on currency code
  String get currencySymbol {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'NGN':
        return '₦';
      case 'GBP':
        return '£';
      case 'EUR':
        return '€';
      default:
        return '\$';
    }
  }
}
