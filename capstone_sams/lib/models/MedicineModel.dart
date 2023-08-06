// medicine_model.dart
class Medicine {
  String? drugId;
  String? drugCode;
  String? name;
  String? instructions;
  DateTime? startDate;
  DateTime? endDate;
  int? quantity;
  int? refills;

  Medicine({
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
    drugId = other.drugId;
    name = other.name;
    instructions = other.instructions;
    startDate = other.startDate;
    endDate = other.endDate;
    quantity = other.quantity;
    refills = other.refills;
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      drugId: json['drugId'],
      drugCode: json['drugCode'],
      name: json['drugName'] as String,
      instructions: json['instructions'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      quantity: json['quantity'],
      refills: json['refills'],
    );
  }
} 
