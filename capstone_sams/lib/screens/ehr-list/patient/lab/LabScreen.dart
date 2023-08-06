import 'package:capstone_sams/providers/LabResultProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/lab/widgets/LabResultCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/Dimensions.dart';
import '../../../../models/LabResultModel.dart';

import '../../../../theme/Sizing.dart';

class LaboratoriesScreen extends StatefulWidget {
  final String index;
  const LaboratoriesScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<LaboratoriesScreen> createState() => _LaboratoriesScreenState();
}

class _LaboratoriesScreenState extends State<LaboratoriesScreen> {
  late Future<List<LabResult>> labresults;

  @override
  void initState() {
    super.initState();
    labresults =
        context.read<LabResultProvider>().fetchLabResults(widget.index);
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      if (constraints.maxWidth >= Dimensions.mobileWidth) {
                        return _tabletView(snapshot);
                      } else {
                        return _mobileView(snapshot);
                      }
                    },
                  );
                } else {
                  return Center(
                    child: Text('No lab results to show'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  GridView _mobileView(AsyncSnapshot<List<LabResult>> snapshot) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: snapshot.data?.length,
      itemBuilder: (context, index) {
        final labresult = snapshot.data![index];

        return LabResultCard(labresult: labresult);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        // childAspectRatio: 16 / 8,
      ),
    );
  }

  GridView _tabletView(AsyncSnapshot<List<LabResult>> snapshot) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: snapshot.data?.length,
      itemBuilder: (context, index) {
        final labresult = snapshot.data![index];
        return LabResultCard(labresult: labresult);
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
