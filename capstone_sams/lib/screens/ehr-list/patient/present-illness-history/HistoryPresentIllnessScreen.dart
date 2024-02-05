import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/scaffolds/ScaffoldTemplate.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/global-widgets/forms/PresentMedHistoryForm.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/present-illness-history/widgets/DiagnosisInfoCard.dart';
import 'package:capstone_sams/screens/home/widgets/CourseDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
