import 'package:capstone_sams/models/medicine_model.dart';
import 'package:flutter/material.dart';

class MedicineProvider with ChangeNotifier {
  final List<Medicine> _medicines = [];

  List<Medicine> get medicines => _medicines;

  void addMedicine(Medicine medicine) {
    _medicines.add(medicine);
    notifyListeners();
  }

  void removeMedicine(int index) {
    if (index >= 0 && index < _medicines.length) {
      _medicines.removeAt(index);
      notifyListeners();
    }
  }

  void editMedicine(int index, Medicine editedMedicine) {
    if (index >= 0 && index < _medicines.length) {
      _medicines[index] = editedMedicine;
      notifyListeners();
    }
  }
}
