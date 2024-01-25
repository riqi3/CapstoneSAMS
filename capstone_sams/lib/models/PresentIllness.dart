class PresentIllness {
  String? illnessID;
  String? illnessName;
  String? complaint;
  String? findings;
  String? diagnosis;
  String? treatment;
  String? patient;
  DateTime? created_at;
  DateTime? updated_at;

  PresentIllness({
    this.illnessID,
    this.illnessName,
    this.complaint,
    this.findings,
    this.diagnosis,
    this.treatment,
    this.patient,
    this.created_at,
    this.updated_at,
  });

  Map<String, dynamic> toJson() {
    return {
      'illnessID': illnessID,
      'illnessName': illnessName,
      'complaint': complaint,
      'findings': findings,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory PresentIllness.fromJson(Map<String, dynamic> json) {
    return PresentIllness(
      illnessID: json['illnessID'].toString(),
      illnessName: json['illnessName'],
      complaint: json['complaint'],
      findings: json['findings'],
      diagnosis: json['diagnosis'],
      treatment: json['treatment'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
    );
  }
}
