import 'dart:convert';
import 'package:capstone_sams/models/MedicalRecordModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/Env.dart';

class MedicalRecordProvider with ChangeNotifier {
  var data = [];
  MedicalRecord? _medicalRecord;
  MedicalRecord? get medicalRecord => _medicalRecord;
  List<MedicalRecord> _medicalRecords = [];
  List<MedicalRecord> get medicalRecords => _medicalRecords;

  int _recordNum = 0;
  List<dynamic> _illnesses = [];
  List<dynamic> _allergies = [];
  List<dynamic> _pastDiseases = [];
  List<dynamic> _familyHistory = [];
  String _lastMensPeriod = '';
  String _patientID = '';

  int get recordNum => _recordNum;
  List<dynamic> get illnesses => _illnesses;
  List<dynamic> get allergies => _allergies;
  List<dynamic> get pastDiseases => _pastDiseases;
  List<dynamic> get familyHistory => _familyHistory;
  String get lastMensPeriod => _lastMensPeriod;
  String get patientID => _patientID;

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
      if (response.statusCode == 200) {
        return MedicalRecord.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return throw Exception('Failed to load medical records');
      }
    } on Exception catch (e) {
      return throw Exception('Failed to load medical records');
    }
  }

  Future<bool> createMedicalRecord(
      String? patientID, MedicalRecord medicalRecord, String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    print(patientID);

    try {
      final response = await http.post(
        Uri.parse('${Env.prefix}/patient/patients/history/create/'),
        headers: header,
        body: jsonEncode(medicalRecord.toJson()),
      ); 
      if (response.statusCode == 201) {
        fetchMedicalRecords(token, patientID);
        notifyListeners();
        return true;
      } else {
        print('cannot add medical record!');
        print("HTTP Response: ${response.statusCode} ${response.body}");
        return false;
      }
    } on Exception catch (e) {
      print(e);
      return false;
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
