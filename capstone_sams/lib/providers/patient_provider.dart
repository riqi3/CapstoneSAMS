import 'dart:convert';

import 'package:capstone_sams/constants/Env.dart';
import 'package:capstone_sams/models/patient.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PatientProvider extends ChangeNotifier {
  List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  Future<List<Patient>> fetchPatients() async {
    final response = await http.get(Uri.parse('${Env.prefix}/api/patients/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Patient> patients = data.map<Patient>((json) {
        return Patient.fromJson(json);
      }).toList();
      return patients;
    } else {
      throw Exception('Failed to fetch patients');
    }
  }
}
