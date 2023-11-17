import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../constants/Env.dart';
import '../models/AccountModel.dart';

class AccountProvider extends ChangeNotifier {
  // List<Account> _accounts = [];

  // List<Account> get account => _accounts;
  Account? _account;
  Account? get acc => _account;
  String? get id => _account?.accountID;
  String? get photo => _account?.profile_photo;
  String? get username => _account?.username;
  String? get password => _account?.password;
  String? get firstName => _account?.firstName;
  String? get lastName => _account?.lastName;
  String? get role => _account?.accountRole;
  String? get token => _account?.token;
  bool get supera => _account!.isSuperuser;
  bool _isAuthentificated = false;

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.prefix}/user/login/'),
        body: {
          'username': username,
          'password': password,
        },
      );
      await Future.delayed(Duration(milliseconds: 3000));
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
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.prefix}/user/logout/${id}'),
      );
      await Future.delayed(Duration(milliseconds: 3000));
      if (response.statusCode == 200) {
        return true;
      } else {
        // The login request failed, so return false
        return false;
      }
    } catch (e) {
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

  bool get isAuthentificated {
    return this._isAuthentificated;
  }

  set isAuthentificated(bool newVal) {
    this._isAuthentificated = newVal;
    this.notifyListeners();
  }
}
