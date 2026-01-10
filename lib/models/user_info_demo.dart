import 'package:json_annotation/json_annotation.dart';

part 'user_info_demo.g.dart';

@JsonSerializable()
class UserInfoDemo {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String accessToken;
  final String refreshToken;

  UserInfoDemo({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserInfoDemo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoDemoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoDemoToJson(this);
}
