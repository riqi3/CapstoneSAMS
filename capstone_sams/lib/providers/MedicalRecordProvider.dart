import 'dart:convert';
import 'package:capstone_sams/models/LabResultModel.dart';
import 'package:capstone_sams/models/MedicalRecordModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/Env.dart';

class MedicalRecordProvider with ChangeNotifier {
  var data = [];
  List<MedicalRecord> _medicalRecords = [];

  List<MedicalRecord> get medicalRecords => _medicalRecords;


Future<MedicalRecord> fetchMedicalRecords(
      String token, String? patientID) async {
    print('provider${patientID}');
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
          Uri.parse('${Env.prefix}/patient/patients/history/${patientID}'),
          headers: header);
      await Future.delayed(Duration(milliseconds: 3000));
      if (response.statusCode == 200) { 
        return MedicalRecord.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return throw Exception('Failed to load medical records');
      }
    } on Exception catch (e) {
      return throw Exception('Failed to load medical records');
    }
  }

  // Future<MedicalRecord> fetchMedicalRecords(String index) async {
  //   try {
  //     final response = await http
  //         .get(Uri.parse('${Env.prefix}/patient/patients/history/${index}'));
  //     await Future.delayed(Duration(milliseconds: 3000));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       List<MedicalRecord> medicalRecords = data.map<MedicalRecord>((json) {
  //         return MedicalRecord.fromJson(json);
  //       }).toList();
  //       return medicalRecords;
  //     } else {
  //       return [];
  //     }
  //   } on Exception catch (e) {
  //     return [];
  //   }
  }

  // void addLabResult(Labresult labresult) async {
  //   try {
  //     final response = await http.post(Uri.parse('${Env.prefix}/ocr/'));
  //     await Future.delayed(Duration(milliseconds: 3000));
  //     if (response.statusCode == 200) {
  //       _medicalRecords.add(labresult);
  //       notifyListeners();
  //     } else {
  //       print('Failed to scan pdf');
  //     }
  //   } on Exception catch (e) {
  //     print('Failed to scan pdf. Error: $e');
  //   }
  // }

  // void removeLabResult(int index) {
  //   if (index >= 0 && index < _medicalRecords.length) {
  //     _medicalRecords.removeAt(index);
  //     notifyListeners();
  //   }
  // }
