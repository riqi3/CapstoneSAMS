import 'package:capstone_sams/providers/LabResultProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/lab/widgets/AddLabResultDialog.dart';
import 'package:capstone_sams/screens/ehr-list/patient/lab/widgets/LabResultCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/PatientModel.dart';
import '../../../../providers/MedicineProvider.dart';
import '../../../../theme/Pallete.dart';
import '../../../../theme/Sizing.dart';
import '../health-record/widgets/PatientInfoCard.dart';

class LaboratoriesScreen extends StatefulWidget {
  final Patient patient;
  const LaboratoriesScreen({super.key, required this.patient});

  @override
  State<LaboratoriesScreen> createState() => _LaboratoriesScreenState();
}

class _LaboratoriesScreenState extends State<LaboratoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final labresultProvider = Provider.of<LabResultProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding * 2,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: labresultProvider.labResults.length,
              itemBuilder: (ctx, index) => LabResultCard(
                labresult: labresultProvider.labResults[index],
                index: index,
              ),
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.orange,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.amber,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.indigo,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.purple,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.pink,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Pallete.mainColor,
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddLabResultDialog(),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }
}
