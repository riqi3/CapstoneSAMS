class Prescription {
  final int presNum;
  final List<dynamic>? medicines;
  final String? account;
  // final int? health_record;
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
      medicines: json['medicines'],
      account: json['account'],
      patientID: json['patient'],
    );
  }
}
