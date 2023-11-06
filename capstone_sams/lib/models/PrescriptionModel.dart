class Prescription {
  final int? presNum;
  final List<dynamic>? medicines;
  final String? account;
  final int? health_record;
  final String? patientID;
  final String? disease;
  // final List<dynamic>? prescriptions;
  // final List<dynamic>? accounts;

  Prescription({
    required this.presNum,
    required this.medicines,
    required this.account,
    required this.patientID,
    required this.health_record,
    required this.disease,
    // required this.prescriptions,
    // required this.accounts,
  });

  Map<String, dynamic> toJson() {
    return {
      'presNum': presNum,
      'medicines': medicines,
      'account': account,
      'patient': patientID,
      'health_record': health_record,
      'disease': disease,
      // 'prescriptions': prescriptions,
      // 'accounts': accounts,
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      presNum: json['presNum'],
      medicines: json['medicines'],
      account: json['account'],
      patientID: json['patient'],
      health_record: json['health_record'],
      disease: json['disease'],
    );
  }
}
