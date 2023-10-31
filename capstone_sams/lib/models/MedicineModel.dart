// medicine_model.dart
import 'PatientModel.dart';

class Medicine {
  Patient? patient;
  String? drugId;
  String? drugCode;
  String? drugName;
  String? instructions;
  DateTime? startDate;
  DateTime? endDate;
  int? quantity;

  Medicine({
    this.patient,
    this.drugId,
    this.drugCode,
    this.drugName,
    this.instructions,
    this.startDate,
    this.endDate,
    this.quantity,
  });

  Medicine.copy(Medicine other) {
    patient = other.patient;
    drugId = other.drugId;
    drugName = other.drugName;
    instructions = other.instructions;
    startDate = other.startDate;
    endDate = other.endDate;
    quantity = other.quantity;
  }

  Map<String, dynamic> toJson() => {
        'drugId': drugId,
        'drugCode': drugCode,
        'drugName': drugName,
        'instructions': instructions,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'quantity': quantity,
      };

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      drugId: json['drugId'],
      drugCode: json['drugCode'],
      drugName: json['drugName'],
      instructions: json['instructions'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      quantity: json['quantity'],
    );
  }
}
