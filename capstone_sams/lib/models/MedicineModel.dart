import 'PatientModel.dart';

class Medicine {
  Patient? patient;
  String? drugId;
  String? drugCode;
  String? drugName;
  String? instructions; 
  int? quantity;

  Medicine({
    this.patient,
    this.drugId,
    this.drugCode,
    this.drugName,
    this.instructions, 
    this.quantity,
  });

  Medicine.copy(Medicine other) {
    patient = other.patient;
    drugId = other.drugId;
    drugName = other.drugName;
    instructions = other.instructions; 
    quantity = other.quantity;
  }

  Map<String, dynamic> toJson() => {
        'drugId': drugId,
        'drugCode': drugCode,
        'drugName': drugName,
        'instructions': instructions, 
        'quantity': quantity,
      };

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      drugId: json['drugId'],
      drugCode: json['drugCode'],
      drugName: json['drugName'],
      instructions: json['instructions'], 
      quantity: json['quantity'],
    );
  }
}
