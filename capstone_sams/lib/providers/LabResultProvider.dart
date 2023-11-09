import 'dart:convert';
import 'package:capstone_sams/models/LabResultModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/Env.dart';

class LabresultProvider with ChangeNotifier {
  var data = [];
  List<Labresult> _labResults = [];

  List<Labresult> get labResults => _labResults;

  Future<List<Labresult>> fetchLabResults(String index) async {
    final response = await http.get(
        Uri.parse('${Env.prefix}/laboratory/select/scan/labresult/${index}/'));
    await Future.delayed(Duration(milliseconds: 3000));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Labresult> labResults = data.map<Labresult>((json) {
        return Labresult.fromJson(json);
      }).toList();
      return labResults;
    } else {
      throw Exception('Failed to fetch lab results');
    }
  }

  void addLabResult(Labresult labresult) async {
    final response = await http.post(Uri.parse('${Env.prefix}/ocr/'));
    await Future.delayed(Duration(milliseconds: 3000));
    if (response.statusCode == 200) {
      _labResults.add(labresult);
      notifyListeners();
    } else {
      print('Failed to scan pdf');
    }
  }

  void removeLabResult(int index) {
    if (index >= 0 && index < _labResults.length) {
      _labResults.removeAt(index);
      notifyListeners();
    }
  }
}
