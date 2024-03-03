import 'package:capstone_sams/models/MedicineModel.dart';

class Prescription {
  final int? presNum;
  final List<dynamic>? medicines;
  final int? account;
  final String? patientID; 

  Prescription({
    required this.presNum,
    required this.medicines,
    required this.account,
    required this.patientID, 
  });

  Map<String, dynamic> toJson() {
    return {
      'presNum': presNum,
      'medicines': medicines,
      'account': account,
      'patient': patientID, 
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      presNum: json['presNum'],
      // medicines: json['medicines'] ,
      // medicines: (json['medicines'] as List)
      //     .map((medicineJson) => Medicine.fromJson(medicineJson))
      //     .toList(),
      // medicines: List<Medicine>.from(
      //     json['medicines'].map((x) => Medicine.fromJson(x))),
      medicines: (json['medicines'] as List)
          .map((medicineJson) => Medicine.fromJson(medicineJson))
          .toList(),
      account: json['account'],
      patientID: json['patient'], 
    );
  }
}
