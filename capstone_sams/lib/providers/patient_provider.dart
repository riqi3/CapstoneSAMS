import 'dart:convert';

import 'package:capstone_sams/constants/Env.dart';
import 'package:capstone_sams/models/patient.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PatientProvider extends ChangeNotifier {
  var data = [];
  List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  Future<List<Patient>> fetchPatients() async {
    final response =
        await http.get(Uri.parse('${Env.prefix}/patient/patients/'));

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

  Future<List<Patient>> searchPatients({String? query}) async {
    final response =
        await http.get(Uri.parse('${Env.prefix}/patient/patients/'));

    try {
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        _patients = data.map((e) => Patient.fromJson(e)).toList();

        if (query != null) {
          _patients = _patients
              .where((element) => element.firstName!
                  .toLowerCase()
                  .contains((query.toLowerCase())))
              .toList();
        } else {
          print('Patient not found!');
        }
      } else {
        throw Exception('Failed to fetch patient');
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return _patients;
  }
}
