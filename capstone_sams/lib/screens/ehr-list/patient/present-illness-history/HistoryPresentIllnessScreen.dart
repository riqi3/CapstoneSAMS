import 'package:capstone_sams/global-widgets/scaffolds/ScaffoldTemplate.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/screens/ehr-list/patient/present-illness-history/widgets/DiagnosisInfoCard.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HistoryPresentIllness extends StatefulWidget {
  ScrollController controller;
  bool isReversed;
  final Patient patient;
  HistoryPresentIllness({
    super.key,
    required this.patient,
    required this.controller,
    required this.isReversed,
  });

  @override
  State<HistoryPresentIllness> createState() => _HistoryPresentIllnessState();
}

class _HistoryPresentIllnessState extends State<HistoryPresentIllness> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldTemplate(
      scrollcontroller: widget.controller,
      column: Column(
        children: [
          DiagnosisInfoCard(
            patient: widget.patient,
            isReversed: widget.isReversed,
          ),
        ],
      ),
    );
  }
}
