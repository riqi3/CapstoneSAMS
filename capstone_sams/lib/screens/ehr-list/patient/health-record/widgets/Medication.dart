import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Medication extends StatefulWidget {
  final Prescription prescription;
  final Account account;
  const Medication({
    super.key,
    required this.prescription,
    required this.account
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
          Text('${widget.account.accountID}'),
          Text('${widget.prescription.medicines}'),
        ],
      ),
    );
  }
}
