import 'package:flutter/material.dart';

import '../../../../models/PatientModel.dart';

class HealthRecordsScreen extends StatelessWidget {
  final Patient patient;
  const HealthRecordsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Text('${patient.firstName}'),
    );
  }
}
