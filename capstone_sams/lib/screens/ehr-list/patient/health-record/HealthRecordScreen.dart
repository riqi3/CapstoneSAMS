import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/AssignDoctorCard.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/PatientInfoCard.dart';
import 'package:flutter/material.dart';
import '../../../../constants/theme/sizing.dart';
import '../../../../models/PatientModel.dart';

class HealthRecordsScreen extends StatefulWidget {
  final Patient patient;

  const HealthRecordsScreen({
    super.key,
    required this.patient,
  });

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
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
          top: Sizing.sectionSymmPadding,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            PatientInfoCard(
              patient: widget.patient,
            ),
            AssignDoctorCard(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => showDialog(
      //     context: context,
      //     builder: (ctx) => CourseDialog(),
      //   ),
      //   child: FaIcon(FontAwesomeIcons.pencil),
      // ),
    );
  }
}
