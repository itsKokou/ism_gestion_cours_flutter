import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginResponseModel {
  final int userId;
  final String token;
  final String username;
  final String nomComplet;
  final List<String> roles;
  
  LoginResponseModel({
    required this.userId,
    required this.token,
    required this.username,
    required this.nomComplet,
    required this.roles,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'token': token,
      'username': username,
      'nomComplet': nomComplet,
      'roles': roles,
    };
  }

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      userId: map['userId'] as int,
      token: map['token'] as String,
      username: map['username'] as String,
      nomComplet: map['nomComplet'] as String,
      roles: List<String>.from((map['roles'] as List<dynamic>).map((role) => role.toString())),
      // List<String>.from((map['roles'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromJson(String source) => LoginResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LoginResponseModel(userId: $userId, token: $token, username: $username, nomComplet: $nomComplet, roles: $roles)';
  }
}
