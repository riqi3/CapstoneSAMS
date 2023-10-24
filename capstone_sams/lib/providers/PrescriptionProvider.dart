import 'dart:convert';

import 'package:capstone_sams/models/PrescriptionModel.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/Env.dart';

class PrescriptionProvider with ChangeNotifier {
  List<Prescription> _prescriptions = [];
  Prescription? _prescription;
  Prescription? get prescription => _prescription;
  int? get presNum => _prescription?.presNum;
  List? get medicines => _prescription?.medicines;
  String? get acc => _prescription?.account;
  int? get healthRecord => _prescription?.health_record;

  List<Prescription> get prescriptions => _prescriptions;

  Future<List<Prescription>> fetchPrescriptions(int? recordNum) async {
    print('HEALTH RECORD NUMBER: ${recordNum}');
    final response = await http
        .get(Uri.parse('${Env.prefix}/cpoe/prescription/get/${recordNum}/'));
    await Future.delayed(Duration(milliseconds: 3000));
    print('PRESCRIPTION RESPOSNSE CODE1: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('PRESCRIPTION RESPOSNSE CODE2: ${response.statusCode}');
      List<Prescription> prescription = data.map<Prescription>((json) {
        return Prescription.fromJson(json);
      }).toList();
      return prescription;
    } else {
      print('PRESCRIPTION RESPOSNSE CODE3: ${response.statusCode}');
      throw Exception('Failed to fetch prescriptions');
    }
  }
  // Future<List<Prescription>> fetchPrescriptions(int recordNum) async {
  //   final response = await http
  //       .get(Uri.parse('${Env.prefix}/cpoe/prescription/get/${recordNum}/'));
  //   print(response.statusCode);
  //   await Future.delayed(Duration(milliseconds: 3000));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     List<Prescription> prescriptions = data.map<Prescription>((json) {
  //       return Prescription.fromJson(json);
  //     }).toList();
  //     return prescriptions;
  //   } else {
  //     throw Exception('Failed to fetch prescriptions');
  //   }
  // }
}
