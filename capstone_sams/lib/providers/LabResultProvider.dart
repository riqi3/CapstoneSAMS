import 'dart:convert';

import 'package:capstone_sams/models/LabResultModel.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/Env.dart';

class LabResultProvider with ChangeNotifier {
  var data = [];
  List<LabResult> _labResults = [];

  List<LabResult> get labResults => _labResults;

  Future<List<LabResult>> fetchLabResults(String index) async {
    await Future.delayed(Duration(milliseconds: 3000));
    final response = await http.get(
        Uri.parse('${Env.prefix}/laboratory/select/scan/labresult/${index}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<LabResult> labResults = data.map<LabResult>((json) {
        return LabResult.fromJson(json);
      }).toList();
      return labResults;
    } else {
      throw Exception('Failed to fetch lab results');
    }
  }

  void addLabResult(LabResult labresult) async {
    await Future.delayed(Duration(milliseconds: 3000));

    final response = await http.post(Uri.parse('${Env.prefix}/ocr/'));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print('SCANNED ${result['result']}');
      _labResults.add(labresult);
      notifyListeners();
    } else {
      print('Failed to scan pdf');
    }
  }

  String trimFileName(String word, String lettersToRemove) {
    String resultingWord = word.replaceAll(RegExp('[$lettersToRemove]'), '');
    resultingWord = resultingWord.trim();
    return resultingWord;
  }

  void removeLabResult(int index) {
    if (index >= 0 && index < _labResults.length) {
      _labResults.removeAt(index);
      notifyListeners();
    }
  }

  // Future<List<Medicine>> searchMedicines({String? query}) async {
  //   await Future.delayed(Duration(milliseconds: 3000));
  //   final response = await http.get(Uri.parse('${Env.prefix}/cpoe/medicines/'));

  //   try {
  //     if (response.statusCode == 200) {
  //       data = json.decode(response.body);
  //       _medicines = data.map((e) => Medicine.fromJson(e)).toList();

  //       if (query != null) {
  //         _medicines = _medicines.where(
  //           (element) {
  //             return element.drugCode!
  //                     .toLowerCase()
  //                     .contains((query.toLowerCase())) ||
  //                 element.drugId!
  //                     .toLowerCase()
  //                     .contains((query.toLowerCase())) ||
  //                 element.name!.toLowerCase().contains((query.toLowerCase()));
  //           },
  //         ).toList();
  //       } else {
  //         print('Medicine not found!');
  //       }
  //     } else {
  //       throw Exception('Failed to fetch medicine');
  //     }
  //   } on Exception catch (e) {
  //     print('error: $e');
  //   }
  //   return _medicines;
  // }

  // void editMedicine(int index, Medicine editedMedicine) {
  //   if (index >= 0 && index < _medicines.length) {
  //     _medicines[index] = editedMedicine;
  //     notifyListeners();
  //   }
  // }
}
