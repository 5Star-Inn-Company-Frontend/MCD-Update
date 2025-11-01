class ReferralModel {
  final String userName;
  final String photo;
  final String referralPlan;
  final String regDate;

  ReferralModel({
    required this.userName,
    required this.photo,
    required this.referralPlan,
    required this.regDate,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      userName: json['user_name'] ?? "",
      photo: json['photo']?.trim() ?? "",
      referralPlan: json['referral_plan'] ?? "",
      regDate: json['reg_date'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_name": userName,
      "photo": photo,
      "referral_plan": referralPlan,
      "reg_date": regDate,
    };
  }

  @override
  String toString() {
    return "Referral(userName: $userName, referralPlan: $referralPlan, regDate: $regDate)";
  }
}
