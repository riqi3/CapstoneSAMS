class PresentIllness {
  String? illnessID;
  String? illnessName;
  String? complaint;
  String? findings;
  String? diagnosis;
  String? treatment;
  String? created_at;
  String? updated_at;
  String? patient;
  int? assignedPhysician;

  PresentIllness({
    this.illnessID,
    this.illnessName,
    this.complaint,
    this.findings,
    this.diagnosis,
    this.treatment,
    this.created_at,
    this.updated_at,
    this.patient,
    this.assignedPhysician,
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
      'patient': patient,
      'assignedPhysician': assignedPhysician,
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
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      assignedPhysician: json['assignedPhysician'],
    );
  }
}
