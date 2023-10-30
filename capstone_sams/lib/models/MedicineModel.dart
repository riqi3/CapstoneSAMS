// medicine_model.dart
import 'PatientModel.dart';

class Medicine {
  Patient? patient;
  String? drugId;
  String? drugCode;
  String? name;
  String? instructions;
  DateTime? startDate;
  DateTime? endDate;
  int? quantity;

  Medicine({
    this.patient,
    this.drugId,
    this.drugCode,
    this.name,
    this.instructions,
    this.startDate,
    this.endDate,
    this.quantity,
  });

  Medicine.copy(Medicine other) {
    patient = other.patient;
    drugId = other.drugId;
    name = other.name;
    instructions = other.instructions;
    startDate = other.startDate;
    endDate = other.endDate;
    quantity = other.quantity;
  }

  Map<String, dynamic> toJson() => {
        'drugId': drugId,
        'drugCode': drugCode,
        'drugName': name,
        'instructions': instructions,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'quantity': quantity,
      };

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      drugId: json['drugId'],
      drugCode: json['drugCode'],
      name: json['drugName'] as String,
      instructions: json['instructions'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      quantity: json['quantity'],
    );
  }
}
