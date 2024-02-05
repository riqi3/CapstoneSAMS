import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/forms/PresentMedHistoryForm.dart';
import 'package:capstone_sams/screens/ehr-list/patient/present-illness-history/HistoryPresentIllnessScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/past-med-history/PastMedicalHistoryScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/treatment/Treatment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants/theme/sizing.dart';
import '../../../models/PatientModel.dart';
import 'health-record/HealthRecordScreen.dart';

class PatientTabsScreen extends StatefulWidget {
  final Patient patient;
  final GlobalKey<_PatientTabsScreenState>? patientTabsScreenKey; // Add this line

  // final int? index;
const PatientTabsScreen({
    Key? key,
    required this.patient,
    this.patientTabsScreenKey, // Add this line
  }) : super(key: key);
  // const PatientTabsScreen({
  //   super.key,
  //   required this.patient,
  //   // required this.index,
  // });

  @override
  State<PatientTabsScreen> createState() => _PatientTabsScreenState();
}
 

class _PatientTabsScreenState extends State<PatientTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    // final accountProvider =
    //     Provider.of<AccountProvider>(context, listen: false);
    // int tabCount = accountProvider.role == 'physician' ? 5 : 1;
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
          PastMedHistory(
            patient: widget.patient,
          ),
          HistoryPresentIllness(
            patient: widget.patient,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PresentMedHistoryForm(
              patient: widget.patient,
            ),
          ),
        ),
        child: FaIcon(FontAwesomeIcons.stethoscope),
      ),
    );
  }
}
