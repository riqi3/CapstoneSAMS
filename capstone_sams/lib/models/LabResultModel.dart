class Labresult {
  final int jsonId;

  final List<dynamic>? labresultTitles;
  final DateTime collectedOn;
  final List<dynamic>? jsonTables;
  final DateTime createdAt;
  final String title;
  final String comment;
  final String patient;

  Labresult({
    required this.jsonId,
    required this.labresultTitles,
    required this.jsonTables,
    required this.collectedOn,
    required this.createdAt,
    required this.title,
    required this.comment,
    required this.patient,
  });

  Map<String, dynamic> toJson() {
    return {
      'jsonId': jsonId,
      'labresultTitles': labresultTitles,
      'collectedOn': collectedOn.toIso8601String(),
      'jsonData': jsonTables,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
      'comment': comment,
      'patient': patient,
    };
  }

  factory Labresult.fromJson(Map<String, dynamic> json) {
    List<dynamic>? tables =
        json['jsonTables'] is List<dynamic> ? json['jsonTables'] : [];
    List<dynamic>? titles =
        json['labresultTitles'] is List<dynamic> ? json['labresultTitles'] : [];

    return Labresult(
      jsonId: json['jsonId'],
      labresultTitles: titles,
      collectedOn: DateTime.parse(json['collectedOn']),
      jsonTables: tables,
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      comment: json['comment'],
      patient: json['patient'],
    );
  }
}
