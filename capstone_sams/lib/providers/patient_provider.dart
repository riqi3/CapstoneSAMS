import 'package:capstone_sams/models/patient.dart';
import 'package:flutter/cupertino.dart';

class PatientProvider extends ChangeNotifier {
  final List<Patient> _patientList = [
    Patient(
      id: '4220',
      name: 'Renz Manuel',
      age: '1',
      sex: 'M',
      birthdate: DateTime.now(),
      datereg: DateTime.now(),
    ),
    Patient(
      id: '4221',
      name: 'Vaughn Nunez',
      age: '10',
      sex: 'F',
      birthdate: DateTime.now(),
      datereg: DateTime.now(),
    ),
  ];

  List<Patient> get patientList => _patientList;

  void addPatient(Patient patient) {
    _patientList.add(patient);
    notifyListeners();
  }

  void removePatient(Patient patient) {
    _patientList.remove(patient);
    notifyListeners();
  }
}
