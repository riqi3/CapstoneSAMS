import 'dart:convert';

import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/Env.dart';

class PrescriptionProvider with ChangeNotifier {
  List<Prescription> _prescriptions = [];
  List<Account> _physicians = [];
  Prescription? _prescription;
  Prescription? get prescription => _prescription;
  // int? get presNum => _prescription?.presNum;
  List? get presc => _prescription?.prescriptions;
  List? get accounts => _prescription?.accounts;
  // String? get acc => _prescription?.account;
  // String? get patientID => _prescription?.patientID;
  Future<List<Prescription>> get prescriptions => Future.value(prescriptions);
  Future<List<Account>> get physicians => Future.value(physicians);

  String _getUrl(String endpoint) {
    return '${Env.prefix}/$endpoint';
  }

  Future<void> fetchPrescriptions(String patientID) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      Uri.parse(
        _getUrl('cpoe/prescription/get/$patientID/'),
      ),
      headers: headers,
    );
    await Future.delayed(Duration(milliseconds: 3000));
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      List<Prescription> newPrescriptions = items["prescriptions"]
          .map<Prescription>((json) => Prescription.fromJson(json))
          .toList();
      List<Account> newAccounts = items["accounts"]
          .map<Account>((json) => Account.fromJson(json))
          .toList();

      if (!listEquals(_prescriptions, newPrescriptions) ||
          !listEquals(_physicians, newAccounts)) {
        _prescriptions = newPrescriptions;
        _physicians = newAccounts;
        print(_prescriptions);
        print(_physicians);
        notifyListeners();
      }
    } else {
      throw Exception(
          'Failed to fetch prescriptions ${jsonDecode(response.body)}');
    }
  }

  // Future<void> fetchPrescriptions(String patientID) async {
  //   final headers = <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   };

  //   final response = await http.get(
  //     Uri.parse(
  //       _getUrl('cpoe/prescription/get/${patientID}/'),
  //     ),
  //     headers: headers,
  //   );
  //   await Future.delayed(Duration(milliseconds: 3000));
  //   if (response.statusCode == 200) {
  //     final items = json.decode(response.body);
  //     List<Prescription> prescriptions = items["prescriptions"]
  //         .map<Prescription>((json) => Prescription.fromJson(json))
  //         .toList();
  //     List<Account> accounts = items["accounts"]
  //         .map<Account>((json) => Account.fromJson(json))
  //         .toList();
  //     // print(prescriptions);
  //     // print(accounts);
  // _prescriptions = prescriptions;
  // _physicians = accounts;
  //     notifyListeners();

  //   } else {
  //     throw Exception(
  //         'Failed to fetch prescriptions ${jsonDecode(response.body)}');
  //   }
  // }

  // Future<List<Prescription>> fetchPrescriptions(String? patientID) async {
  //   print('PATIENT ID: ${patientID}');
  //   final response = await http
  //       .get(Uri.parse('${Env.prefix}/cpoe/prescription/get/${patientID}/'));
  //   await Future.delayed(Duration(milliseconds: 3000));
  //   print('PRESCRIPTION RESPOSNSE CODE1: ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);

  //     print('PRESCRIPTION RESPOSNSE CODE2: ${response.statusCode}');
  //     List<Prescription> prescription = data.map<Prescription>((json) {
  //       return Prescription.fromJson(json);
  //     }).toList();
  //     return prescription;
  //   } else {
  //     print('PRESCRIPTION RESPOSNSE CODE3: ${response.statusCode}');
  //     throw Exception('Failed to fetch prescriptions');
  //   }
  // }

  // Future<List<Prescription>> fetchPrescriptions(int recordNum) async {
  //   final response = await http
  //       .get(Uri.parse('${Env.prefix}/cpoe/prescription/get/${recordNum}/'));
  //   print(response.statusCode);
  //   await Future.delayed(Duration(milliseconds: 3000));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     List<Prescription> prescriptions = data.map<Prescription>((json) {
  //       return Prescription.fromJson(json);
  //     }).toList();
  //     return prescriptions;
  //   } else {
  //     throw Exception('Failed to fetch prescriptions');
  //   }
  // }
}
