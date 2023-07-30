import 'dart:convert';

import 'package:capstone_sams/models/MedicineModel.dart';
 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    await Future.delayed(Duration(milliseconds: 3000));
    final response = await http.get(Uri.parse('${Env.prefix}/cpoe/medicines/'));
 
    try {
      if (response.statusCode == 200 ) {
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
