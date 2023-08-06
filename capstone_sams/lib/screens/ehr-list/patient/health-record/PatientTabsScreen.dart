import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:flutter/material.dart';

import '../../../../models/PatientModel.dart';
import '../../../../theme/Sizing.dart';
import '../lab/LabScreen.dart';
import '../order-entry/CpoeAnalyzeScreen.dart';
import 'HealthRecordScreen.dart';

class PatientTabsScreen extends StatefulWidget {
  final Patient patient;
  final String index;

  const PatientTabsScreen({
    super.key,
    required this.patient,
    required this.index,
  });

  @override
  State<PatientTabsScreen> createState() => _PatientTabsScreenState();
}

class _PatientTabsScreenState extends State<PatientTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ValueDashboard(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizing.appbarHeight),
        // child: SearchBarTabs(),
        child: ValuePatientRecord(
          tabController: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          HealthRecordsScreen(
            patient: widget.patient,
          ),
          LaboratoriesScreen(index: widget.index),
          // OrderEntryScreen(),
          CpoeAnalyzeScreen(),
        ],
      ),
    );
  }
}
