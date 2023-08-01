// medicine_model.dart
import 'dart:convert';

class LabResult {
  final int jsonId;
  final Map<String, dynamic> jsonData;
  final DateTime createdAt;

  LabResult({
    required this.jsonId,
    required this.jsonData,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'jsonId': jsonId,
      'jsonData': jsonData,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LabResult.fromJson(Map<String, dynamic> json) {
    return LabResult(
      jsonId: json['jsonId'],
      // jsonData: LabResult.fromJson(jsonDecode(json['jsonData'])),
      jsonData: json['jsonData'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
