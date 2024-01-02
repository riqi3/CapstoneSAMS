import 'dart:convert';
import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/Env.dart';

class MedicineProvider with ChangeNotifier {
  var data = [];
  List<Medicine> _medicines = [];

  List<Medicine> get medicines => _medicines;

  Future<List<Medicine>> fetchMedicines(String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(Uri.parse('${Env.prefix}/cpoe/medicines/'),
        headers: header);
    await Future.delayed(Duration(milliseconds: 3000));
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

  Future<List<Medicine>> searchMedicines({String? query, String? token}) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(Uri.parse('${Env.prefix}/cpoe/medicines/'),
        headers: header);
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
                  element.drugName!
                      .toLowerCase()
                      .contains((query.toLowerCase()));
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

  Future<bool> saveToPrescription(int? accountId, String? patientId,
      String? finalPrediction, String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final medicinesJson =
        _medicines.map((medicine) => medicine.toJson()).toList();

    final data = <String, dynamic>{
      'medicines': medicinesJson,
      'account': accountId,
      'patient': patientId,
      'disease': finalPrediction,
    };
    try {
      final response = await http.post(
        Uri.parse('${Env.prefix}/cpoe/prescription/save/'),
        headers: header,
        body: jsonEncode(data),
      );
      await Future.delayed(Duration(milliseconds: 3000));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('cannot add medicine!');
        return false;
      }
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateAmount(String? accountId, String? patientId) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final medicinesJson =
        _medicines.map((medicine) => medicine.toJson()).toList();

    final data = <String, dynamic>{
      'account': accountId,
      'medicines': medicinesJson,
    };
    try {
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
    } on Exception catch (e) {
      print(e);
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

  void resetState() {
    Future.delayed(Duration.zero, () {
      data = [];
      _medicines = [];
      notifyListeners();
    });
  }
}
