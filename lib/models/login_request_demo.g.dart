// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_demo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestDemo _$LoginRequestDemoFromJson(Map<String, dynamic> json) =>
    LoginRequestDemo(
      username: json['username'] as String,
      password: json['password'] as String,
      expiresInMins: (json['expiresInMins'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$LoginRequestDemoToJson(LoginRequestDemo instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'expiresInMins': instance.expiresInMins,
    };
