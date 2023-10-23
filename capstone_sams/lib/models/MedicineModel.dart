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
  int? refills;

  Medicine({
    this.patient,
    this.drugId,
    this.drugCode,
    this.name,
    this.instructions,
    this.startDate,
    this.endDate,
    this.quantity,
    this.refills,
  });

  Medicine.copy(Medicine other) {
    patient = other.patient;
    drugId = other.drugId;
    name = other.name;
    instructions = other.instructions;
    startDate = other.startDate;
    endDate = other.endDate;
    quantity = other.quantity;
    refills = other.refills;
  }

  Map<String, dynamic> toJson() => {
        'drugId': drugId,
        'drugCode': drugCode,
        'name': name,
        'instructions': instructions,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'quantity': quantity,
        'refills': refills,
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
