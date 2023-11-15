import 'dart:convert';
import 'package:capstone_sams/constants/Env.dart';
import 'package:capstone_sams/models/HealthRecordModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HealthRecordProvider with ChangeNotifier {
  HealthRecord? _healthrecord;
  HealthRecord? get healthrecord => _healthrecord;
  int? get recordNum => _healthrecord?.recordNum;
  Map<String, dynamic>? get diseases => _healthrecord?.diseases;
  String? get patient => _healthrecord?.patient;

  Future<bool> setRecord(String patientID) async {
    final response = await http
        .get(Uri.parse('${Env.prefix}/patient/patients/history/${patientID}'));
    await Future.delayed(Duration(milliseconds: 3000));
    if (response.statusCode == 200) {
      _healthrecord = HealthRecord.fromJson(jsonDecode(response.body));
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
