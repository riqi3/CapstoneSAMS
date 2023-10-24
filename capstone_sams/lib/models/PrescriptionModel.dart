class Prescription {
  final int presNum;
  final List<dynamic>? medicines;
  final String? account;
  final int? health_record;

  Prescription({
    required this.presNum,
    required this.medicines,
    required this.account,
    required this.health_record,
  });

  Map<String, dynamic> toJson() {
    return {
      'presNum': presNum,
      'medicines': medicines,
      'account': account,
      'health_record': health_record,
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      presNum: json['presNum'],
      medicines: json['medicines'],
      account: json['account'],
      health_record: json['health_record'],
    );
  }
}
