class MedicalRecord {
  String? recordNum;
  List<dynamic>? illnesses;
  List<dynamic>? allergies;
  List<dynamic>? pastDisease;
  List<dynamic>? familyHistory;
  String? lastMensPeriod;
  String? patient;

  MedicalRecord({
    this.recordNum,
    this.illnesses,
    this.allergies,
    this.pastDisease,
    this.familyHistory,
    this.lastMensPeriod,
    this.patient,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordNum': recordNum,
      'illnesses': illnesses,
      'allergies': allergies,
      'pastDisease': pastDisease,
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
List<dynamic>? pastDisease =
        json['pastDisease'] is List<dynamic> ? json['pastDisease'] : [];
List<dynamic>? familyHistory =
        json['familyHistory'] is List<dynamic> ? json['familyHistory'] : [];

    return MedicalRecord(
      recordNum: json['recordNum'].toString(),
      illnesses: illnesses,
      allergies: allergies,
      pastDisease: pastDisease,
      familyHistory: familyHistory,
      lastMensPeriod: json['lastMensPeriod'],
      patient: json['patient'].toString(),
    );
  }
}
