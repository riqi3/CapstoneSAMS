class MedicalRecord {
  String? recordNum;
  List<dynamic>? illnesses;
  List<dynamic>? allergies;
  List<dynamic>? pastDiseases;
  List<dynamic>? familyHistory;
  String? lastMensPeriod;
  String? patient;

  MedicalRecord({
    this.recordNum,
    this.illnesses,
    this.allergies,
    this.pastDiseases,
    this.familyHistory,
    this.lastMensPeriod,
    this.patient,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordNum': recordNum,
      'illnesses': illnesses,
      'allergies': allergies,
      'pastDiseases': pastDiseases,
      'familyHistory': familyHistory,
      'lastMensPeriod': lastMensPeriod,
      'patient': patient,
    };
  }

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    List<dynamic>? illnesses =
        json['illnesses'] is List<dynamic> ? json['illnesses'] : [];
    List<dynamic>? allergies =
        json['allergies'] is List<dynamic> ? json['allergies'] : [];
    List<dynamic>? pastDiseases =
        json['pastDiseases'] is List<dynamic> ? json['pastDiseases'] : [];
    List<dynamic>? familyHistory =
        json['familyHistory'] is List<dynamic> ? json['familyHistory'] : [];

    return MedicalRecord(
      recordNum: json['recordNum'].toString(),
      illnesses: illnesses,
      allergies: allergies,
      pastDiseases: pastDiseases,
      familyHistory: familyHistory,
      lastMensPeriod: json['lastMensPeriod'],
      patient: json['patient'].toString(),
    );
  }
}
