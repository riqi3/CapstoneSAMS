import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/Env.dart';

class HealthCheckProvider extends ChangeNotifier {
  String feverOption = 'No';
  String coughOption = 'No';
  String fatigueOption = 'No';
  String difficultyBreathingOption = 'No';
  String genderOption = 'M';
  int age = 1;
  String bloodPressureOption = 'Low';
  String cholesterolLevelOption = 'Low';

  List<Map<String, dynamic>> top3Predictions = [];

  Future<void> sendDataToBackend(String token) async {
    try {
      final url =
          Uri.parse('${Env.prefix}/diagnostics/create_diagnostic_record/');
      final header = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };
      final body = json.encode({
        'fever': feverOption,
        'cough': coughOption,
        'fatigue': fatigueOption,
        'difficulty_breathing': difficultyBreathingOption,
        'age': age.toString(),
        'gender': genderOption,
        'blood_pressure': bloodPressureOption,
        'cholesterol_level': cholesterolLevelOption,
        'outcome_variable': 'Negative',
      });
      final response = await http.post(
        url,
        headers: header,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        top3Predictions =
            List<Map<String, dynamic>>.from(responseData['top3_predictions']);
        notifyListeners();
      } else {
        print('Error sending data to server: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }

  void setGenderOption(String? value) {
    genderOption = value ?? 'M';
    notifyListeners();
  }

  void setFeverOption(String? value) {
    feverOption = value ?? 'No';
    notifyListeners();
  }

  void setCoughOption(String? value) {
    coughOption = value ?? 'No';
    notifyListeners();
  }

  void setFatigueOption(String? value) {
    fatigueOption = value ?? 'No';
    notifyListeners();
  }

  void setDifficultyBreathingOption(String? value) {
    difficultyBreathingOption = value ?? 'No';
    notifyListeners();
  }

  void setAge(int? value) {
    age = value ?? 1;
    notifyListeners();
  }

  void setBloodPressureOption(String? value) {
    bloodPressureOption = value ?? 'Low';
    notifyListeners();
  }

  void setCholesterolLevelOption(String? value) {
    cholesterolLevelOption = value ?? 'Low';
    notifyListeners();
  }
}
