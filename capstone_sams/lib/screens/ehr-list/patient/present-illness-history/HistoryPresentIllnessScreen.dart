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
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldTemplate(
      scrollcontroller: _scrollController,
      column: Column(
        children: [
          DiagnosisInfoCard(
            patient: widget.patient,
          ),
        ],
      ),
      // fablocation: FloatingActionButtonLocation.centerFloat,
      // fab: FloatingActionButton(
      //   onPressed: () {
      //     _scrollController.animateTo(
      //       0,
      //       duration: Duration(seconds: 1),
      //       curve: Curves.easeInOut,
      //     );
      //   },
      //   child: Text('test'),
      // ),
    );
  }
}
