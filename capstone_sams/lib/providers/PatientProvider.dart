import 'dart:convert';
import 'package:capstone_sams/constants/Env.dart';
import 'package:capstone_sams/models/ProviderResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/PatientModel.dart';

class PatientProvider extends ChangeNotifier {
  Patient? _patient;
  Patient? get patient => _patient;
  String? get id => _patient!.patientID;
  String? get firstName => _patient?.firstName;
  String? get middleName => _patient?.middleInitial;
  String? get lastName => _patient?.lastName;
  int? get age => _patient?.age;
  String? get gender => _patient?.gender;
  String? get patientStatus => _patient?.patientStatus;
  String? get birthDate => _patient?.birthDate;
  String? get department => _patient?.department;
  int? get yrLevel => _patient?.yrLevel;
  String? get studNumber => _patient?.studNumber;
  String? get address => _patient?.address;
  double? get height => _patient?.height;
  double? get weight => _patient?.weight;
  String? get phone => _patient?.phone;
  String? get email => _patient?.email;
  // int? get assignedPhysician => _patient?.assignedPhysician;
  var data = [];
  List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  Future<List<Patient>> fetchPatients(String token) async {
    // print("Role: $role, ID: $id");
    try {
      // final uri = role == 'physician'
      //     ? Uri.parse('${Env.prefix}/user/physician/${id}/patients/')
      //     : Uri.parse('${Env.prefix}/patient/patients/');

      final header = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      final response = await http
          .get(Uri.parse('${Env.prefix}/patient/patients/'), headers: header);
      await Future.delayed(Duration(milliseconds: 1000));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Patient> patients = data
            .where((json) => json['isDeleted'] == false).map<Patient>((json) {
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

  Future<ProviderResponse<bool>> createPatientRecord(Patient patient, String token,
      int? accountID, String role, int id) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      // 'Authorization': 'Bearer $token',
    };
    try {
      var body = patient.toJson();
      body['account'] = accountID;
      print(body);
      final response = await http.post(
        Uri.parse('${Env.prefix}/patient/patients/create/'),
        headers: header,
        body: jsonEncode(body),
        // body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        fetchPatients(token);
        notifyListeners();
        // return true;
        return ProviderResponse(success: true, data: true);
      } else {
        print('cannot add patient record!');
        print("HTTP Response: ${response.statusCode} ${response.body}");

        // return false;
        return ProviderResponse(success: false, data: false, errorMessage: 'Failed to create patient record: ${response.body}');
      }
    } on Exception catch (e) {
      print(e);
      // return false;
      return ProviderResponse(success: false, data: false, errorMessage: 'Failed to create patient record: ${e}');
    }
  }

  Future<Patient?> fetchPatient(String? index, String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
          Uri.parse('${Env.prefix}/patient/patients/${index}'),
          headers: header);
      if (response.statusCode == 200) {
        return Patient.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } on Exception catch (e) {
      return null;
    }
  }

  Future<List<Patient>> searchPatients({String? query, String? token}) async {
    try {
      final header = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };
      final response = await http
          .get(Uri.parse('${Env.prefix}/patient/patients/'), headers: header);
      await Future.delayed(Duration(milliseconds: 3000));
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
                  element.middleInitial!
                      .toLowerCase()
                      .contains((query.toLowerCase())) ||
                  element.studNumber!
                      .toLowerCase()
                      .contains((query.toLowerCase()));
            },
          ).toList();
        } else {
          print('Patient not found!');
        }
      } else {
        return _patients;
      }
    } on Exception catch (e) {
      return _patients;
    }
    return _patients;
  }
}
