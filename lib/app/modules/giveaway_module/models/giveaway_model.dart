class GiveawayModel {
  final int id;
  final String userName;
  final String amount;
  final int quantity;
  final String type;
  final String typeCode;
  final int status;
  final String description;
  final String image;
  final int views;
  final int showContact;
  final String public;
  final String createdAt;
  final String updatedAt;
  final String expiredAt;

  GiveawayModel({
    required this.id,
    required this.userName,
    required this.amount,
    required this.quantity,
    required this.type,
    required this.typeCode,
    required this.status,
    required this.description,
    required this.image,
    required this.views,
    required this.showContact,
    required this.public,
    required this.createdAt,
    required this.updatedAt,
    required this.expiredAt,
  });

  factory GiveawayModel.fromJson(Map<String, dynamic> json) {
    return GiveawayModel(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? '',
      amount: json['amount'] ?? '',
      quantity: json['quantity'] ?? 0,
      type: json['type'] ?? '',
      typeCode: json['type_code'] ?? '',
      status: json['status'] ?? 0,
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      views: json['views'] ?? 0,
      showContact: json['show_contact'] ?? 0,
      public: json['public'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      expiredAt: json['expired_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'amount': amount,
      'quantity': quantity,
      'type': type,
      'type_code': typeCode,
      'status': status,
      'description': description,
      'image': image,
      'views': views,
      'show_contact': showContact,
      'public': public,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'expired_at': expiredAt,
    };
  }
}

class GiveawayRequesterModel {
  final int id;
  final int giveawayId;
  final String userName;
  final String amount;
  final String receiver;
  final int status;
  final String createdAt;
  final String updatedAt;

  GiveawayRequesterModel({
    required this.id,
    required this.giveawayId,
    required this.userName,
    required this.amount,
    required this.receiver,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GiveawayRequesterModel.fromJson(Map<String, dynamic> json) {
    return GiveawayRequesterModel(
      id: json['id'] ?? 0,
      giveawayId: json['giveaway_id'] ?? 0,
      userName: json['user_name'] ?? '',
      amount: json['amount'] ?? '',
      receiver: json['receiver'] ?? '',
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class GiveawayGiverModel {
  final String userName;
  final String companyName;
  final String fullName;
  final String photo;

  GiveawayGiverModel({
    required this.userName,
    required this.companyName,
    required this.fullName,
    required this.photo,
  });

  factory GiveawayGiverModel.fromJson(Map<String, dynamic> json) {
    return GiveawayGiverModel(
      userName: json['user_name'] ?? '',
      companyName: json['company_name'] ?? '',
      fullName: json['full_name'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}

class GiveawayDetailModel {
  final GiveawayModel giveaway;
  final List<GiveawayRequesterModel> requesters;
  final GiveawayGiverModel giver;
  final bool completed;

  GiveawayDetailModel({
    required this.giveaway,
    required this.requesters,
    required this.giver,
    required this.completed,
  });

  factory GiveawayDetailModel.fromJson(Map<String, dynamic> json) {
    return GiveawayDetailModel(
      giveaway: GiveawayModel.fromJson(json['giveaway']),
      requesters: (json['requesters'] as List)
          .map((e) => GiveawayRequesterModel.fromJson(e))
          .toList(),
      giver: GiveawayGiverModel.fromJson(json['giver']),
      completed: json['completed'] ?? false,
    );
  }
}
