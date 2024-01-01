import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/screens/ehr-list/patient/present-illness-history/forms/PresentMedHistoryForm.dart';
import 'package:capstone_sams/screens/ehr-list/patient/present-illness-history/widgets/DiagnosisCard.dart';
import 'package:capstone_sams/screens/home/widgets/CourseDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding * 2,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        controller: _controller,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: DiagnosisCard(),
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
