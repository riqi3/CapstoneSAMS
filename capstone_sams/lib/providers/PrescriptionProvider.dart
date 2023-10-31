import 'dart:convert';

import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/MedicineModel.dart';
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
  // List? get presc => _prescription?.prescriptions;
  // List? get accounts => _prescription?.accounts;
  // String? get acc => _prescription?.account;
  // String? get patientID => _prescription?.patientID;
  List<Prescription> get prescripts => _prescriptions;
  int? get presNum => _prescription?.presNum;
  // List? get medicines => _prescription?.medicines;
  String? get acc => _prescription?.account;
  String? get patientID => _prescription?.patientID;

  Future<List<Prescription>> get prescriptions => Future.value(_prescriptions);
  Future<List<Account>> get physicians => Future.value(_physicians);

  String _getUrl(String endpoint) {
    return '${Env.prefix}/$endpoint';
  }

  Future<void> fetchPrescriptions(String patientID) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      Uri.parse(
        _getUrl('cpoe/prescription/get-patient/${patientID}/'),
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
        notifyListeners();
      }
    } else {
      throw Exception(
          'Failed to fetch patient prescriptions ${jsonDecode(response.body)}');
    }
  }

  Future updatePrescription(
      Prescription prescription, Medicine medicine, String patientID) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.put(
        Uri.parse(
          _getUrl(
              'cpoe/prescription/get-prescription/update/${prescription.presNum}'),
        ),
        headers: headers,
        body: jsonEncode(medicine.toJson()));
    await Future.delayed(Duration(milliseconds: 3000));

    if (response.statusCode == 200) {
      fetchPrescriptions(patientID);
      notifyListeners();
    } else {
      throw Exception('Failed to update prescription');
    }
  }

  Future removePrescription(Prescription prescription, String patientID) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode({'account': prescription.account});
    final response = await http.delete(
      Uri.parse(_getUrl(
          'cpoe/prescription/get-prescription/delete/${prescription.presNum}')),
      headers: headers,
      body: body,
    );
    await Future.delayed(Duration(milliseconds: 3000));
    if (response.statusCode == 204) {
      fetchPrescriptions(patientID);
    } else {
      throw Exception(
          'Failed to delete prescription ${jsonDecode(response.body)}');
    }
  }
}
