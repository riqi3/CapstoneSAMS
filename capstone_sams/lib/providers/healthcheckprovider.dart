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

  Future<void> sendDataToBackend() async {
    final url =
        Uri.parse('${Env.prefix}/diagnostics/create_diagnostic_record/');
    final response = await http.post(
      url,
      body: {
        'fever': feverOption,
        'cough': coughOption,
        'fatigue': fatigueOption,
        'difficulty_breathing': difficultyBreathingOption,
        'age': age.toString(),
        'gender': genderOption,
        'blood_pressure': bloodPressureOption,
        'cholesterol_level': cholesterolLevelOption,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final top3Predictions = responseData['top3_predictions'];

      for (var prediction in top3Predictions) {
        print(
            'Disease: ${prediction['disease']}, Probability: ${prediction['probability']}');
      }
    } else {
      print('Error sending data to server: ${response.statusCode}');
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
