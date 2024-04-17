import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/forms/present-illness/PresentIllnessForm.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/lab/LabScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/present-illness-history/HistoryPresentIllnessScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/past-med-history/PastMedicalHistoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../constants/theme/sizing.dart';
import '../../../models/PatientModel.dart';
import 'health-record/HealthRecordScreen.dart';

// ignore: must_be_immutable
class PatientTabsScreen extends StatefulWidget {
  int selectedPage;
  final Patient patient;

  final String? index;
  PatientTabsScreen({
    Key? key,
    required this.patient,
    required this.index,
    required this.selectedPage,
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
  late SpeedDial speedDial;
  ScrollController _scrollController = ScrollController();
  bool _isReversed = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: widget.selectedPage == 0 ? 0 : widget.selectedPage,
      length: 4,
      vsync: this,
    );
    speedDials(tabController.index);
    tabController.addListener(() {
      speedDials(tabController.index);
    });
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget speedDials(int index) {
    setState(() {
      if (index == 2) {
        speedDial = SpeedDial(
          label: Text('Menu'),
          activeLabel: Text('Close'),
          animatedIcon: AnimatedIcons.menu_close, 
          visible: true,
          children: [
            SpeedDialChild(
              label: 'Diagnose',
              child: FaIcon(FontAwesomeIcons.stethoscope),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PresentIllnessForm(
                    patient: widget.patient,
                  ),
                ),
              ),
            ),
            // SpeedDialChild(
            //   label: 'Navigate',
            //   child: FaIcon(FontAwesomeIcons.upDown),
            //   onTap: () => _scrollController.offset >
            //           _scrollController.position.minScrollExtent
            //       ? _scrollUp()
            //       : _scrollDown(),
            // ),
            SpeedDialChild(
              label: 'Sort',
              child: _isReversed
                  ? FaIcon(FontAwesomeIcons.arrowUp91)
                  : FaIcon(FontAwesomeIcons.arrowDown19),
              onTap: () {
                setState(() {
                  _isReversed = !_isReversed;
                });
              },
            ),
          ],
        );
      } else {
        speedDial = SpeedDial( 
          label: Text('Diagnose'),
          child: FaIcon(FontAwesomeIcons.stethoscope),
          onPress: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PresentIllnessForm(
                patient: widget.patient,
              ),
            ),
          ),
        );
      }
    });
    return speedDial;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);

    // ignore: unnecessary_null_comparison
    final bool canAccessForm = accountProvider == null ||
        (accountProvider.acc?.accountRole != 'physician' &&
            accountProvider.acc?.accountRole != 'nurse');
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
            controller: _scrollController,
            isReversed: _isReversed,
          ),
          LaboratoriesScreen(
            index: widget.index,
          ),
        ],
      ),
      floatingActionButton:
          canAccessForm ? null : speedDials(tabController.index),
    );
  }
}
