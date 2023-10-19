import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/Env.dart';

class Account {
  final String accountID;
  final String username;
  final String profile_photo;
  final String? password;
  final String firstName;
  final String lastName;
  final String accountRole;
  String? token;
  final bool isActive;
  final bool isStaff;
  final bool isSuperuser;

  Account({
    required this.accountID,
    required this.username,
    required this.profile_photo,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.accountRole,
    this.token,
    required this.isActive,
    required this.isStaff,
    required this.isSuperuser,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountID: json['accountID'],
      username: json['username'],
      profile_photo: json['profile_photo'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      accountRole: json['accountRole'],
      token: json['token'],
      isActive: json['is_active'],
      isStaff: json['is_staff'],
      isSuperuser: json['is_superuser'],
    );
  }

  Map<String, dynamic> toJson() => {
        'accountID': accountID,
        'username': username,
        'profile_photo': profile_photo,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'accountRole': accountRole,
        'token': token,
        'is_active': isActive,
        'is_staff': isStaff,
        'is_superuser': isSuperuser,
      };

  static Future<Account> login(String username, String password) async {
    final url = Uri.parse('${Env.prefix}/login/');
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final token = decodedResponse['token'];
      final accountJson = decodedResponse['account'];

      // Save the token to shared preferences for later use
      // ...

      return Account.fromJson(accountJson);
    } else {
      throw Exception('Failed to login');
    }
  }
}
