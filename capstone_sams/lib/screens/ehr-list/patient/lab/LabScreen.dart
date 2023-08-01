import 'package:capstone_sams/providers/LabResultProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/lab/widgets/AddLabResultDialog.dart';
import 'package:capstone_sams/screens/ehr-list/patient/lab/widgets/LabResultCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/Dimensions.dart';
import '../../../../models/LabResultModel.dart';
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
  late Future<List<LabResult>> labresults;
  @override
  void initState() {
    super.initState();
    labresults = context.read<LabResultProvider>().fetchLabResults();
  }

  @override
  Widget build(BuildContext context) {
    // final labresultProvider = Provider.of<LabResultProvider>(context);
    // late List<LabResult> lr = [];
    // late List<LabResult> b = labresultProvider.labResults;

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
            FutureBuilder(
              future: labresults,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth >= Dimensions.mobileWidth) {
                      return _tabletView(snapshot);
                    } else {
                      return _mobileView(snapshot);
                    }
                  },
                );
              },
            ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: labresultProvider.labResults.length,
            //   itemBuilder: (ctx, index) => LabResultCard(
            //     labresult: labresultProvider.labResults[index],
            //     index: index,
            //   ),
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //   backgroundColor: Pallete.mainColor,
      //   onPressed: () => showDialog(
      //     context: context,
      //     builder: (_) => AddLabResultDialog(),
      //   ),
      //   child: ConstrainedBox(
      //     constraints: BoxConstraints(maxWidth: 200),
      //     child: Row(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Icon(Icons.add),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  GridView _mobileView(AsyncSnapshot<List<LabResult>> snapshot) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(
        left: Sizing.sectionSymmPadding,
        right: Sizing.sectionSymmPadding,
        top: Sizing.sectionSymmPadding * 2,
        bottom: Sizing.sectionSymmPadding * 4,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: snapshot.data?.length,
      itemBuilder: (context, index) {
        final labresult = snapshot.data![index];

        return LabResultCard(labresult: labresult, index: index);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 16 / 8,
      ),
    );
  }

  GridView _tabletView(AsyncSnapshot<List<LabResult>> snapshot) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(
        left: Sizing.sectionSymmPadding,
        right: Sizing.sectionSymmPadding,
        top: Sizing.sectionSymmPadding * 2,
        bottom: Sizing.sectionSymmPadding * 4,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: snapshot.data?.length,
      itemBuilder: (context, index) {
        final labresult = snapshot.data![index];
        return LabResultCard(labresult: labresult, index: index);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        // childAspectRatio: 16 / 10,
      ),
    );
  }
}
