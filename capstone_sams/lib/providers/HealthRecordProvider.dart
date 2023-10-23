import 'dart:convert';

import 'package:capstone_sams/constants/Env.dart';
import 'package:capstone_sams/models/HealthRecordModel.dart';
import 'package:flutter/material.dart';
import '../models/PatientModel.dart';

import 'package:http/http.dart' as http;

class HealthRecordProvider with ChangeNotifier {
  // List<HealthRecordProvider> _healthrecords = [];

  // List<HealthRecordProvider> get healthrecords => _healthrecords;
  HealthRecord? _healthrecord;
  HealthRecord? get healthrecord => _healthrecord;
  int? get recordNum => _healthrecord?.recordNum;
  List? get diseases => _healthrecord?.diseases;
  String? get patient => _healthrecord?.patient;

  // Future<List<HealthRecord>> fetchHealthRecords(int? healthRecordID) async {
  //   final response = await http.get(
  //       Uri.parse('${Env.prefix}/cpoe/prescription/get/${healthRecordID}'));
  //   await Future.delayed(Duration(milliseconds: 3000));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     List<Prescription> prescription = data.map<Prescription>((json) {
  //       return Prescription.fromJson(json);
  //     }).toList();
  //     return prescription;
  //   } else {
  //     throw Exception('Failed to fetch prescriptions');
  //   }
  // }

  Future<void> setRecord(String patientID) async {
    final response = await http
        .get(Uri.parse('${Env.prefix}/patient/patients/history/${patientID}'));
    await Future.delayed(Duration(milliseconds: 3000));
    if (response.statusCode == 200) {
      _healthrecord = HealthRecord.fromJson(jsonDecode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to fetch patient');
    }
  }
}
