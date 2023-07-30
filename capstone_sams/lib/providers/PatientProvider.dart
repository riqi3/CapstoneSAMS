import 'dart:convert';

import 'package:capstone_sams/constants/Env.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/PatientModel.dart';

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

  Future<Patient> fetchPatient() async {
    final response =
        await http.get(Uri.parse('${Env.prefix}/patient/patients/${int}'));

    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
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
          _patients = _patients.where(
            (element) {
              return element.firstName!
                      .toLowerCase()
                      .contains((query.toLowerCase())) ||
                  element.lastName!
                      .toLowerCase()
                      .contains((query.toLowerCase())) ||
                  element.middleName!
                      .toLowerCase()
                      .contains((query.toLowerCase())) ||
                  element.patientId!
                      .toLowerCase()
                      .contains((query.toLowerCase()));
            },
          ).toList();
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
