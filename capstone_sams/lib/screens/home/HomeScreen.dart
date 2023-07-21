import 'package:capstone_sams/constants/Dimensions.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';

import 'package:capstone_sams/screens/ehr-list/ehr_list_page.dart';
import 'package:capstone_sams/screens/home/widgets/PatientSection.dart';

import 'package:flutter/material.dart';

import '../../theme/sizing.dart';
import '../medical_notes/medical_notes_page.dart';
import 'widgets/NotesSection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String ehrTitle = 'Health Records';
  String medNotesTitle = 'Your Notes';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: ValueDashboard(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Sizing.headerHeight),
          child: ValueHomeAppBar(),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth >= Dimensions.mobileWidth) {
                return _tabletView(context, ehrTitle, medNotesTitle);
              } else {
                return _mobileView(context, ehrTitle, medNotesTitle);
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget _mobileView(context, medNotesTitle, ehrTitle) {
  return Column(
    children: [
      Center(
        child: EHRSection(
          title: ehrTitle,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EHRListScreen(),
              ),
            );
            print('to ehr list');
          },
        ),
      ),
      Center(
        child: NotesSection(
          title: medNotesTitle,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicalNotes(),
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget _tabletView(context, ehrTitle, medNotesTitle) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: EHRSection(
            title: ehrTitle,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EHRListScreen(),
                ),
              );
              print('object');
            },
          ),
        ),
        Expanded(
          child: NotesSection(
            title: medNotesTitle,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicalNotes(),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
