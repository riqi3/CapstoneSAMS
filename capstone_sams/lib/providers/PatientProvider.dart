import 'dart:convert';

import 'package:capstone_sams/constants/Env.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/PatientModel.dart';

class PatientProvider extends ChangeNotifier {
  Patient? _patient;
  Patient? get patient => _patient;
  String? get id => _patient?.patientId;
  String? get firstName => _patient?.firstName;
  String? get middleName => _patient?.middleName;
  String? get lastName => _patient?.lastName;
  int? get age => _patient?.age;
  String? get gender => _patient?.gender;
  DateTime? get birthDate => _patient?.birthDate;
  DateTime? get registrationDate => _patient?.registration;
  String? get phone => _patient?.phone;
  String? get email => _patient?.email;
  var data = [];
  List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  Future<List<Patient>> fetchPatients(String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http
          .get(Uri.parse('${Env.prefix}/patient/patients/'), headers: header);
      await Future.delayed(Duration(milliseconds: 3000));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Patient> patients = data.map<Patient>((json) {
          return Patient.fromJson(json);
        }).toList();
        patients = patients.reversed.toList();
        return patients;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Patient?> fetchPatient(String index, String token) async {
    try {
      final header = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
          Uri.parse('${Env.prefix}/patient/patients/${index}'),
          headers: header);
      await Future.delayed(Duration(milliseconds: 3000));
      if (response.statusCode == 200) {
        return Patient.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Patient>> searchPatients({String? query, String? token}) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final response = await http
        .get(Uri.parse('${Env.prefix}/patient/patients/'), headers: header);
    await Future.delayed(Duration(milliseconds: 3000));
    try {
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        _patients = data.map((e) => Patient.fromJson(e)).toList();

        if (query != null) {
          _patients = _patients.where(
            (element) {
              return element.firstName
                      .toLowerCase()
                      .contains((query.toLowerCase())) ||
                  element.lastName
                      .toLowerCase()
                      .contains((query.toLowerCase())) ||
                  element.middleName!
                      .toLowerCase()
                      .contains((query.toLowerCase())) ||
                  element.patientId
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
