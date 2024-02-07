import 'package:capstone_sams/global-widgets/scaffolds/ScaffoldTemplate.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/screens/ehr-list/patient/present-illness-history/widgets/DiagnosisInfoCard.dart';
import 'package:flutter/material.dart';

class HistoryPresentIllness extends StatefulWidget {
  final Patient patient;
  const HistoryPresentIllness({
    super.key,
    required this.patient,
  });

  @override
  State<HistoryPresentIllness> createState() => _HistoryPresentIllnessState();
}

class _HistoryPresentIllnessState extends State<HistoryPresentIllness> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldTemplate(
      column: Column(
        children: [
          DiagnosisInfoCard(
            patient: widget.patient,
          ),
        ],
      ),
    );
  }
}
