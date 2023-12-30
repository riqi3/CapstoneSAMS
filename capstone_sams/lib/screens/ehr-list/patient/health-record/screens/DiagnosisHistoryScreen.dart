import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/DiagnosisCard.dart';
import 'package:capstone_sams/screens/home/widgets/CourseDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiagnosisHistoryScreen extends StatefulWidget {
  final Patient patient;

  const DiagnosisHistoryScreen({
    super.key,
    required this.patient,
  });

  @override
  State<DiagnosisHistoryScreen> createState() => _DiagnosisHistoryScreenState();
}

class _DiagnosisHistoryScreenState extends State<DiagnosisHistoryScreen> {
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

        //     Container(
        //   height: 300,
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     itemCount: entries.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return Container(
        //         height: 50,
        //         color: Colors.amber[colorCodes[index]],
        //         child: Center(
        //           child: Text('Entry ${entries[index]}'),
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => CourseDialog(),
        ),
        child: FaIcon(FontAwesomeIcons.pencil),
      ),
    );
  }
}
