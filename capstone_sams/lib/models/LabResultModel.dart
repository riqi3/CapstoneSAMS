// medicine_model.dart
class LabResult {
  String? pdfId;
  String? title;
  String? comment;
  String? pdf;

  LabResult({
    this.pdfId,
    this.title,
    this.comment,
    this.pdf,
  });

  LabResult.copy(LabResult other) {
    pdfId = other.pdfId;
    title = other.title;
    comment = other.comment;
    pdf = other.pdf;
  }

  factory LabResult.fromJson(Map<String, dynamic> json) {
    return LabResult(
      pdfId: json['pdfId'],
      title: json['title'],
      comment: json['comment'],
      pdf: json['pdf'],
    );
  }
}
