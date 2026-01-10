import 'package:json_annotation/json_annotation.dart';

part 'login_request_demo.g.dart';

@JsonSerializable()
class LoginRequestDemo {
  final String username;
  final String password;
  final int expiresInMins;

  LoginRequestDemo({
    required this.username,
    required this.password,
    this.expiresInMins = 60,
  });

  factory LoginRequestDemo.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDemoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestDemoToJson(this);
}
