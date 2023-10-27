class Prescription {
  // final int presNum;
  // final List<dynamic>? medicines;
  // final String? account;
  // // final int? health_record;
  // final String? patientID;
  final List<dynamic>? prescriptions;
  final List<dynamic>? accounts;

  Prescription({
    required this.prescriptions,
    required this.accounts,
  });

  Map<String, dynamic> toJson() {
    return {
      'prescriptions': prescriptions,
      'accounts': accounts,
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      prescriptions: json['prescriptions'],
      accounts: json['accounts'],
    );
  }
}
