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
  int? get id => _account?.accountID;
  String? get photo => _account?.profile_photo;
  String? get username => _account?.username;
  String? get password => _account?.password;
  String? get firstName => _account?.firstName;
  String? get middleName => _account?.middleName;
  String? get lastName => _account?.lastName;
  String? get role => _account?.accountRole;
  String? get token => _account?.token;
  bool get supera => _account!.isSuperuser;
  bool _isAuthentificated = false;

  Future<Account?> fetchAccount(int? accountID, String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
          Uri.parse('${Env.prefix}/user/users/account/${accountID}'),
          headers: header); 
      if (response.statusCode == 200) {
        return Account.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } on Exception catch (e) {
      return null;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
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
        isAuthentificated = true;
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
    print("Account Details: ${_account?.toJson()}");
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
