import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/global-widgets/forms/PresentMedHistoryForm.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/present-illness-history/widgets/DiagnosisCard.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            DiagnosisCard(
              patient: widget.patient,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => PresentMedHistoryForm(),
        ),
        child: FaIcon(FontAwesomeIcons.pencil),
      ),
    );
  }
}
