class UserEntity {
  UserEntity({ required this.username, this.password});

  String username;
  String? password;

  factory UserEntity.fromJson(Map<String, dynamic>? json) {
    return UserEntity(
      username: json?['username'] as String,
       password: json?['password'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}

// class UserEntity {
//   final String id;
//   final String username;
//   final String email;

//   UserEntity({
//     required this.id,
//     required this.username,
//     required this.email,
//   });
// }
