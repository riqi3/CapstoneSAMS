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
  List<Prescription> get prescripts => _prescriptions;
  int? get presNum => _prescription?.presNum;
  String? get acc => _prescription?.account;
  String? get patientID => _prescription?.patientID;

  Future<List<Prescription>> get prescriptions => Future.value(_prescriptions);
  Future<List<Account>> get physicians => Future.value(_physicians);

  String _getUrl(String endpoint) {
    return '${Env.prefix}/$endpoint';
  }

  Future<void> fetchPrescriptions(String patientID, String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse(
        _getUrl('cpoe/prescription/get-patient/${patientID}/'),
      ),
      headers: header,
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
      Prescription prescription, String patientID, String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final response = await http.put(
      Uri.parse(
        _getUrl(
            'cpoe/prescription/get-prescription/update/${prescription.presNum}'),
      ),
      headers: header,
      body: jsonEncode(prescription),
    );
    await Future.delayed(Duration(milliseconds: 3000));

    if (response.statusCode == 200) {
      fetchPrescriptions(patientID, token);
      notifyListeners();
    } else {
      throw Exception('Failed to update prescription');
    }
  }

  Future updatePrescriptionAmount(
      Prescription prescription, String patientID, String token) async {
    final header = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

      Uri.parse(
    final response = await http.put(
        _getUrl(
            'cpoe/prescription/get-prescription/update-amount/${prescription.presNum}'),
      ),
      headers: header,
      body: jsonEncode(prescription),
    await Future.delayed(Duration(milliseconds: 3000));
    );
    if (response.statusCode == 200) {

      fetchPrescriptions(patientID);
      notifyListeners();
    } else {
        throw Exception('Failed to update prescription amount');
    }
  }

  Future removePrescription(Prescription prescription, String patientID, String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'account': prescription.account});
    final response = await http.delete(
      Uri.parse(_getUrl(
          'cpoe/prescription/get-prescription/delete/${prescription.presNum}')),
      headers: header,
      body: body,
    );
    await Future.delayed(Duration(milliseconds: 3000));
    if (response.statusCode == 204) {
      fetchPrescriptions(patientID, token);
    } else {
      throw Exception(
          'Failed to delete prescription ${jsonDecode(response.body)}');
    }
  }

  Future removeMedicine(Prescription prescription, String patientID,
      String? drugId, String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'account': prescription.account});
    final response = await http.delete(
      Uri.parse(_getUrl(
          'cpoe/prescription/get-prescription-${prescription.presNum}/delete-medicine/${drugId}')),
      headers: header,
      body: body,
    );
    await Future.delayed(Duration(milliseconds: 3000));
    if (response.statusCode == 204) {
      fetchPrescriptions(patientID, token);
    } else {
      throw Exception('Failed to delete medicine ${jsonDecode(response.body)}');
    }
  }
}
