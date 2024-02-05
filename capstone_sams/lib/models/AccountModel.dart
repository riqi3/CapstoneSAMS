import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/Env.dart';

class Account {
  int? accountID;
  final String? username;
  String? profile_photo;
  final String? password;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  String? accountRole;
  String? token;
  final bool? isActive;
  final bool? isStaff;
  final bool isSuperuser;
  final String? suffixTitle;

  Account({
    this.accountID,
    this.username,
    this.profile_photo,
    this.password,
    this.firstName,
    this.middleName,
    this.lastName,
    this.suffixTitle,
    this.accountRole,
    this.token,
    this.isActive,
    this.isStaff,
    required this.isSuperuser,
  });

  Map<String, dynamic> toJson() => {
        'accountID': accountID,
        'username': username,
        'profile_photo': profile_photo,
        'password': password,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'suffixTitle': suffixTitle,
        'accountRole': accountRole,
        'token': token,
        'is_active': isActive,
        'is_staff': isStaff,
        'is_superuser': isSuperuser,
      };

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountID: json['accountID'],
      username: json['username'],
      profile_photo: json['profile_photo'],
      password: json['password'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      suffixTitle: json['suffixTitle'],
      accountRole: json['accountRole'],
      token: json['token'],
      isActive: json['is_active'],
      isStaff: json['is_staff'],
      isSuperuser: json['is_superuser'],
    );
  }

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
      final accountJson = decodedResponse['account'];

      return Account.fromJson(accountJson);
    } else {
      throw Exception('Failed to login');
    }
  }
}
