import 'package:capstone_sams/models/MedicineModel.dart';

class Prescription {
  final String? presID;
  final List<dynamic>? medicines;
  final int? account;
  final String? patientID; 
  final String? illnessID; 

  Prescription({
    required this.presID,
    required this.medicines,
    required this.account,
    required this.patientID, 
    required this.illnessID, 
  });

  Map<String, dynamic> toJson() {
    return {
      'presID': presID,
      'medicines': medicines,
      'account': account,
      'patient': patientID, 
      'illness': illnessID, 
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      presID: json['presID'],
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
      illnessID: json['illness'], 
    );
  }
}
