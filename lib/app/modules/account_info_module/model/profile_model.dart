import 'dart:developer' as dev;

class ProfileModel {
  final String? fullName;
  final String? email;
  final String? phoneNo;
  final String? userName;
  final String? photo;
  final int? level;
  final String? totalFunding;
  final String? totalTransaction;
  final int? totalReferral;
  final String? wallet;
  final String? bonus;
  final String? commission;
  final String? points;
  final String? generalMarket;

  ProfileModel({
    this.fullName,
    this.email,
    this.phoneNo,
    this.userName,
    this.photo,
    this.level,
    this.totalFunding,
    this.totalTransaction,
    this.totalReferral,
    this.wallet,
    this.bonus,
    this.commission,
    this.points,
    this.generalMarket,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    
    // Extract nested data
    final data = json['data'] as Map<String, dynamic>?;
    final user = data?['user'] as Map<String, dynamic>?;
    final balance = data?['balance'] as Map<String, dynamic>?;
    
    dev.log("ProfileModel: User data - ${user?.toString()}");
    dev.log("ProfileModel: Balance data - ${balance?.toString()}");
    
    // Safe integer conversion helper
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }
    
    final model = ProfileModel(
      userName: user?['user_name']?.toString(),
      email: user?['email']?.toString(),
      phoneNo: user?['phoneno']?.toString(),
      photo: user?['photo']?.toString(),
      level: toInt(user?['level']),
      fullName: user?['user_name']?.toString(), // Using username as fullName since it's not in response
      totalFunding: data?['funds']?.toString() ?? '0',
      totalTransaction: data?['transactions']?.toString() ?? '0',
      totalReferral: toInt(data?['referrals']) ?? 0,
      wallet: balance?['wallet']?.toString() ?? '0',
      bonus: balance?['bonus']?.toString() ?? '0',
      commission: balance?['agent_commision']?.toString() ?? '0',
      points: balance?['points']?.toString() ?? '0',
      generalMarket: balance?['general_market']?.toString() ?? '0',
    );
    
    dev.log("ProfileModel: Created successfully - Name: ${model.fullName}, Email: ${model.email}, Level: ${model.level}");
    return model;
  }
}
