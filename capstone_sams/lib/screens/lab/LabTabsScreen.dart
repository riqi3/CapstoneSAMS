import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/screens/patient-record/PatientTabsScreen.dart';

import 'package:flutter/material.dart';

import '../../models/patient.dart';
import '../../theme/sizing.dart';
 
import '../order-entry/CPOEScreen.dart';
import 'LabScreen.dart';
 

class LabTabsScreen extends StatefulWidget {
  final Patient patient;
  const LabTabsScreen({
    super.key,
    required this.patient,
  });

  @override
  State<LabTabsScreen> createState() => _LabTabsScreenState();
}

class _LabTabsScreenState extends State<LabTabsScreen>
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
          PatientTabsScreen(patient: widget.patient),
          const LaboratoriesScreen(),
          const CPOEScreen(),
        ],
      ),
    );
  }
}
