import 'package:capstone_sams/declare/ValueDeclaration.dart';

import 'package:flutter/material.dart';

import '../../global-widgets/search-bar/SearchBarTabs.dart';
import '../../models/patient.dart';

class PatientRecordScreen extends StatelessWidget {
  final Patient patient;
  const PatientRecordScreen({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ValueDashboard(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SearchBarTabs(),
      ),
      body: Column(
        children: [
          Text(patient.firstName),
        ],
      ),
    );
  }
}
