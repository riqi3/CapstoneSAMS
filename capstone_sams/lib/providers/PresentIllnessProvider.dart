import 'dart:convert';

import 'package:capstone_sams/constants/Env.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PresentIllnessProvider extends ChangeNotifier {
  PresentIllness? _presentIllness;
  PresentIllness? get presentIllness => _presentIllness;
  String? get id => _presentIllness!.illnessID;
  String? get illnessName => _presentIllness?.illnessName;
  String? get complaint => _presentIllness?.complaint;
  String? get findings => _presentIllness?.findings;
  String? get diagnosis => _presentIllness?.diagnosis;
  String? get treatment => _presentIllness?.treatment;
  DateTime? get created_at => _presentIllness?.created_at;
  DateTime? get updated_at => _presentIllness?.updated_at;

  Future<PresentIllness> fetchComplaints(String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
          Uri.parse('${Env.prefix}/patient/patients/complaints/'),
          headers: header);
      await Future.delayed(Duration(milliseconds: 3000));
      if (response.statusCode == 200) {
        return PresentIllness.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return throw Exception('Failed to load present illness records');
      }
    } on Exception catch (e) {
      return throw Exception('Failed to load present illness records');
    }
  }
}
