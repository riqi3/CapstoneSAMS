import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Medication extends StatefulWidget {
  final Prescription prescription;
  const Medication({
    super.key,
    required this.prescription,
  });

  @override
  State<Medication> createState() => _MedicationState();
}

class _MedicationState extends State<Medication> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('${widget.prescription.accounts}'),
          Text('${widget.prescription.prescriptions}'),
        ],
      ),
    );
  }
}
