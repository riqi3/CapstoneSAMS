// medicine_model.dart
class LabResult {
  final int jsonId;
  final Map<String, dynamic> jsonData;
  final DateTime createdAt;
  final String title;
  final String comment;

  LabResult({
    required this.jsonId,
    required this.jsonData,
    required this.createdAt,
    required this.title,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'jsonId': jsonId,
      'jsonData': jsonData,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
      'comment': comment,
    };
  }

  factory LabResult.fromJson(Map<String, dynamic> json) {
    return LabResult(
      jsonId: json['jsonId'],
      // jsonData: LabResult.fromJson(jsonDecode(json['jsonData'])),
      jsonData: json['jsonData'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      comment: json['comment'],
    );
  }
}
