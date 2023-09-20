// medicine_model.dart
class LabResult {
  final int jsonId;
  // final Map<String, dynamic> jsonTables;
  final List<dynamic>? jsonTables;
  final DateTime createdAt;
  final String title;
  final String comment;
  final String patient;

  LabResult({
    required this.jsonId,
    required this.jsonTables,
    required this.createdAt,
    required this.title,
    required this.comment,
    required this.patient,
  });

  Map<String, dynamic> toJson() {
    return {
      'jsonId': jsonId,
      'jsonData': jsonTables,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
      'comment': comment,
      'patient': patient,
    };
  }

  // factory LabResult.fromJson(Map<String, dynamic> json) {
  //   Map<String, dynamic>? tables =
  //       json['jsonTables'] is Map<String, dynamic> ? json['jsonTables'] : {};
  //   return LabResult(
  //     jsonId: json['jsonId'],
  //     // jsonData: LabResult.fromJson(jsonDecode(json['jsonData'])),
  //     jsonTables: tables,
  //     createdAt: DateTime.parse(json['createdAt']),
  //     title: json['title'],
  //     comment: json['comment'],
  //     patient: json['patient'],
  //   );
  // }
  factory LabResult.fromJson(Map<String, dynamic> json) {
  List<dynamic>? tables =
      json['jsonTables'] is List<dynamic> ? json['jsonTables'] : [];
  return LabResult(
    jsonId: json['jsonId'],
    jsonTables: tables,
    createdAt: DateTime.parse(json['createdAt']),
    title: json['title'],
    comment: json['comment'],
    patient: json['patient'],
  );
}
}
