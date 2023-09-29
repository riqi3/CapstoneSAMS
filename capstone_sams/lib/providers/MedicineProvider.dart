import 'dart:convert';

import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../constants/Env.dart';

class MedicineProvider with ChangeNotifier {
  var data = [];
  List<Medicine> _medicines = [];

  List<Medicine> get medicines => _medicines;

  Future<List<Medicine>> fetchMedicines() async {
    await Future.delayed(Duration(milliseconds: 3000));
    final response = await http.get(Uri.parse('${Env.prefix}/cpoe/medicines/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Medicine> medicines = data.map<Medicine>((json) {
        return Medicine.fromJson(json);
      }).toList();
      return medicines;
    } else {
      throw Exception('Failed to fetch medicines');
    }
  }

  Future<List<Medicine>> searchMedicines({String? query}) async {
    final response = await http.get(Uri.parse('${Env.prefix}/cpoe/medicines/'));
    await Future.delayed(Duration(milliseconds: 3000));
    try {
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        _medicines = data.map((e) => Medicine.fromJson(e)).toList();

        if (query != null) {
          _medicines = _medicines.where(
            (element) {
              return element.drugCode!
                      .toLowerCase()
                      .contains((query.toLowerCase())) ||
                  element.drugId!
                      .toLowerCase()
                      .contains((query.toLowerCase())) ||
                  element.name!.toLowerCase().contains((query.toLowerCase()));
            },
          ).toList();
        } else {
          print('Medicine not found!');
        }
      } else {
        throw Exception('Failed to fetch medicine');
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return _medicines;
  }

  Future<bool> saveToPrescription(String? accountId, String? patientId) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final medicinesJson =
        _medicines.map((medicine) => medicine.toJson()).toList();

    final data = <String, dynamic>{
      'medicines': medicinesJson,
      'account': accountId,
      'patient': patientId,
    };

    // final data = <String, dynamic>{
    //   'medicines': _medicines,
    //   'account': accountId,
    //   'patient': patientId,
    // };
    print('DATADATA$data');

    final response = await http.post(
      Uri.parse('${Env.prefix}/cpoe/prescription/save/'),
      headers: headers,
      body: jsonEncode(data),
    );
    await Future.delayed(Duration(milliseconds: 3000));
    if (response.statusCode == 200) {
      return true;
    } else {
      print('cannot add medicine!');
      return false;
    }
    // try {
    // } on Exception catch(error){
    //   print('error saving prescription $error');
    //   return false;
    // }
  }

    Future<bool> updateAmount(String? patientId) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final medicinesJson =
        _medicines.map((medicine) => medicine.toJson()).toList();

    final data = <String, dynamic>{
      'medicines': medicinesJson,
    };

    final response = await http.post(
      Uri.parse('${Env.prefix}/cpoe/prescription/update/${patientId}'),
      headers: headers,
      body: jsonEncode(data),
    );
    await Future.delayed(Duration(milliseconds: 3000));
    if (response.statusCode == 200) {
      return true;
    } else {
      print('cannot update medicine!');
      return false;
    }
  }

  void addMedicine(Medicine medicine) {
    _medicines.add(medicine);
    notifyListeners();
  }

  void removeMedicine(int index) {
    if (index >= 0 && index < _medicines.length) {
      _medicines.removeAt(index);
      notifyListeners();
    }
  }

  void editMedicine(int index, Medicine editedMedicine) {
    if (index >= 0 && index < _medicines.length) {
      _medicines[index] = editedMedicine;
      notifyListeners();
    }
  }
}
