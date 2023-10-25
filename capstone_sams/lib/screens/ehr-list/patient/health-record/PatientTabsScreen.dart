import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/theme/sizing.dart';
import '../../../../models/PatientModel.dart';

import '../lab/LabScreen.dart';
import '../order-entry/CpoeAnalyzeScreen.dart';
import 'HealthRecordScreen.dart';

class PatientTabsScreen extends StatefulWidget {
  final Patient patient; 
  final int index;

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
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    int tabCount = accountProvider.role == 'physician' ? 3 : 2;
    tabController = TabController(length: tabCount, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
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
            // index: widget.index,
          ),
          LaboratoriesScreen(index: widget.index),
          // OrderEntryScreen(),
          if (accountProvider.role == 'physician')
            CpoeAnalyzeScreen(patient: widget.patient, index: widget.index),
        ],
      ),
    );
  }
}
