import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list/models/login_request_demo.dart';
import 'package:todo_list/models/user_info_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const DemoScreen(),
    );
  }
}

class LoginRequest {
  final String username;
  final String password;
  final int expiresInMins;

  LoginRequest({
    required this.username,
    required this.password,
    this.expiresInMins = 60,
  });

  /// Convert LoginRequest object to json / map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'expiresInMins': expiresInMins,
    };
  }
}

// fetch('https://dummyjson.com/user/login', {
//   method: 'POST',
//   headers: { 'Content-Type': 'application/json' },
//   body: JSON.stringify({

//     username: 'emilys',
//     password: 'emilyspass',
//     expiresInMins: 30, // optional, defaults to 60
//   }),
// })
// .then(res => res.json())
// .then(console.log);

// {
//   "id": 1,
//   "username": "emilys",
//   "email": "emily.johnson@x.dummyjson.com",
//   "firstName": "Emily",
//   "lastName": "Johnson",
//   "gender": "female",
//   "image": "https://dummyjson.com/icon/emilys/128",
//   "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...", // JWT accessToken (for backward compatibility) in response and cookies
//   "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." // refreshToken in response and cookies
// }

class UserInfo {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String accessToken;
  final String refreshToken;

  UserInfo({
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

  /// from json / map to UserInfo object
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      image: json['image'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  String userEmail = '---';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Demo Screen'),
          ElevatedButton(
            onPressed: () async {
              final uri = Uri.parse('https://dummyjson.com/user/login');
              // final request = LoginRequest(
              //   username: 'emilys',
              //   password: 'emilyspass',
              //   expiresInMins: 30,
              // );

              final request = LoginRequestDemo(
                username: 'emilys',
                password: 'emilyspass',
                expiresInMins: 30,
              );

              final response = await http.post(
                uri,
                headers: {'Content-Type': 'application/json'},

                // /// Convert Map to String json by jsonEncode
                // body: jsonEncode({
                //   'username': 'emilys',
                //   'password': 'emilyspass',
                //   'expiresInMins': 30,
                // }),

                // /// Convert Object to String json by jsonEncode
                body: jsonEncode(request.toJson()),
              );

              if (response.statusCode == 200) {
                // /// Api return String json -> convert json / map by jsonDecode
                // final data = jsonDecode(response.body);
                // print('Response Data: $data');
                // userEmail = data['email'];
                /// userEmail = data['accessToken'];

                /// Api return String json -> convert json/map -> convert to object
                // final data = jsonDecode(response.body);
                // final userInfo = UserInfo.fromJson(data);
                // print('User Info: ${userInfo.email}');
                // print('Access Token: ${userInfo.accessToken}');
                // userEmail = userInfo.email;

                /// Using generated model from json_serializable
                final data = jsonDecode(response.body);
                final userInfo = UserInfoDemo.fromJson(data);
                print('User Info: ${userInfo.email}');
                print('Access Token: ${userInfo.accessToken}');
                userEmail = userInfo.email;
                setState(() {});
              } else {
                print('Error: ${response.statusCode}');
              }
            },
            child: Text('Call API'),
          ),
          Text('User Email: $userEmail'),
        ],
      ),
    );
  }
}
