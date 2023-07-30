import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../constants/Env.dart';
import '../models/AccountModel.dart';

class AccountProvider extends ChangeNotifier {
  Account? _account;

  Account? get acc => _account;
  String? get id => _account?.accountID;
  String? get username => _account?.username;
  String? get password => _account?.password;
  String? get firstName => _account?.firstName;
  String? get lastName => _account?.lastName;
  String? get role => _account?.accountRole;

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${Env.prefix}/user/login/'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // The user was authenticated, so store the account data in the provider
      final data = jsonDecode(response.body);
      final account = Account.fromJson(data);
      setAccount(account);
      return true;
    } else {
      // The login request failed, so return false
      return false;
    }
  }

  
  void setAccount(Account account) {
    _account = account;
    notifyListeners();
  }

  void setNull() {
    _account = null;
    notifyListeners();
  }
}
