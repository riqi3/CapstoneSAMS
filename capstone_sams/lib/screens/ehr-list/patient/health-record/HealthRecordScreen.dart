import 'package:capstone_sams/global-widgets/scaffolds/ScaffoldTemplate.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/PatientInfoCard.dart';
import 'package:flutter/material.dart';
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
    return ScaffoldTemplate(
      column: Column(
        children: [
          PatientInfoCard(
            patient: widget.patient,
          ),
          // AssignDoctorCard(),
        ],
      ),
    );
  }
}
