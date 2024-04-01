import 'dart:convert';

import 'package:capstone_sams/constants/Env.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PresentIllnessProvider extends ChangeNotifier {
  PresentIllness? _presentIllness;
  PresentIllness? get presentIllness => _presentIllness;
  String? get id => _presentIllness?.illnessID;
  String? get illnessName => _presentIllness?.illnessName;
  String? get complaint => _presentIllness?.complaint;
  String? get findings => _presentIllness?.findings;
  String? get diagnosis => _presentIllness?.diagnosis;
  String? get treatment => _presentIllness?.treatment;
  String? get created_at => _presentIllness?.created_at;
  String? get updated_at => _presentIllness?.updated_at;
  String? get patient => _presentIllness?.patient;
  int? get created_by => _presentIllness?.created_by;
  bool? get isDeleted => _presentIllness?.isDeleted;
  List<PresentIllness> _presentIllnessList = [];

  Future<List<PresentIllness>> get presentIllnesses =>
      Future.value(_presentIllnessList);

  Future<PresentIllness> fetchComplaint(String token, String? illnessID) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
          Uri.parse(
              '${Env.prefix}/patient/patients/complaint/illness/${illnessID}'),
          headers: header);
      await Future.delayed(Duration(milliseconds: 1000));
      if (response.statusCode == 200) {
        return PresentIllness.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return throw Exception('Failed to load complaint');
      }
    } catch (e) {
      print('WHY COMPLAINT ${e}');
      return throw Exception('Failed to load complaint');
    }
  }

  Future<List<PresentIllness>> fetchComplaints(
      String token, String? patientID) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
          Uri.parse(
              '${Env.prefix}/patient/patients/complaints/illness/${patientID}'),
          headers: header);
      await Future.delayed(Duration(milliseconds: 2000));
      if (response.statusCode == 200) {
        final items = json.decode(response.body);
        List<PresentIllness> presentIllness = items.map<PresentIllness>((json) {
          return PresentIllness.fromJson(json);
        }).toList();
        presentIllness = presentIllness.reversed.toList();

        return presentIllness;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> createComplaint(PresentIllness presentIllness, String token,
      String? patientID, int? accountID) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      // 'Authorization': 'Bearer $token',
    };

    try {
      var body = presentIllness.toJson();
      // body['account'] = accountID;
      // print(body);
      final response = await http.post(
        Uri.parse(
            '${Env.prefix}/patient/patients/complaints/create/${patientID}/${accountID}'),
        headers: header,
        body: jsonEncode(body),
      );
      await Future.delayed(Duration(milliseconds: 1000));
      if (response.statusCode == 201) {
        _presentIllness = presentIllness;
        notifyListeners();
        // fetchComplaints(token, patientID);
        return true;
      } else {
        print('cannot add complaint record!');
        print("HTTP Response: ${response.statusCode} ${response.body}");
        return false;
      }
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateComplaint(PresentIllness presentIllness, String? patientID,
      int? accountID, String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.put(
        Uri.parse(
          '${Env.prefix}/patient/patients/complaints/update/${presentIllness.illnessID}/${accountID}',
        ),
        headers: header,
        body: jsonEncode(presentIllness),
      );

      if (response.statusCode == 200) {
        fetchComplaints(token, patientID);
        notifyListeners();
        return true;
      } else {
        print('Failed to update illnesss');
        print("HTTP Response: ${response.statusCode} ${response.body}");
        return false;
      }
    } on Exception catch (e) {
      print('Failed to update illness');
      return false;
    }
  }

  Future<bool> removeComplaint(PresentIllness presentIllness, String? patientID,
      int? accountID, String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    // final body = jsonEncode({"accountID": accountID});
    final body = jsonEncode(
        {'accountID': accountID!, 'illnessID': presentIllness.illnessID});

    try {
      final response = await http.post(
        Uri.parse(
          '${Env.prefix}/patient/patients/complaints/illness/delete/',
        ),
        headers: header,
        // body: jsonEncode(presentIllness.toJson()),
        body: body,
      );
      if (response.statusCode == 204) {
        fetchComplaints(token, patientID);
        notifyListeners();
        return true;
      } else {
        print('Failed to delete illness ${jsonDecode(response.body)}');
        print("HTTP Response: ${response.statusCode} ${response.body}");
        return false;
      }
    } on Exception catch (e) {
      print('Failed to delete illness. Error: $e');
      return false;
    }
  }
}
