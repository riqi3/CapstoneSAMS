class HealthRecord {
  final int? recordNum;
  final Map<String, dynamic>? symptoms;
  final Map<String, dynamic>? diseases;
  final String? patient;

  HealthRecord({
    required this.recordNum,
    required this.symptoms,
    required this.diseases,
    required this.patient,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordNum': recordNum,
      'symptoms': symptoms,
      'diseases': diseases,
      'patient': patient,
    };
  }

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      recordNum: json['recordNum'],
      symptoms: json['symptoms'],
      diseases: json['diseases'],
      patient: json['patient'],
    );
  }
}
