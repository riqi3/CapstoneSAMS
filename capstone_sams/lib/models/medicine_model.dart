// medicine_model.dart
class Medicine {
  String? name;
  String? instructions;
  DateTime? startDate;
  DateTime? endDate;
  int? quantity;
  int? refills;

  Medicine({
    this.name,
    this.instructions,
    this.startDate,
    this.endDate,
    this.quantity,
    this.refills,
  });

  Medicine.copy(Medicine other) {
    name = other.name;
    instructions = other.instructions;
    startDate = other.startDate;
    endDate = other.endDate;
    quantity = other.quantity;
    refills = other.refills;
  }
}
