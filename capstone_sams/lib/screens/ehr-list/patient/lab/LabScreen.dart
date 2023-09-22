import 'package:capstone_sams/providers/LabResultProvider.dart';

import 'package:capstone_sams/screens/ehr-list/patient/lab/widgets/LabresultCard.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../constants/Dimensions.dart';
import '../../../../constants/Strings.dart';
import '../../../../constants/theme/sizing.dart';
import '../../../../models/LabResultModel.dart';

class LaboratoriesScreen extends StatefulWidget {
  final int index;
  // final Labresult labresult1;
  const LaboratoriesScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<LaboratoriesScreen> createState() => _LaboratoriesScreenState();
}

class _LaboratoriesScreenState extends State<LaboratoriesScreen> {
  late Future<List<Labresult>> labresults;

  @override
  void initState() {
    super.initState();
    labresults = context
        .read<LabresultProvider>()
        .fetchLabResults(widget.index.toString());
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
                List<Labresult> dataToShow = [];
                int dataLength = 0;
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(Strings.noLabResults),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  dataToShow = snapshot.data!;
                  dataLength = dataToShow.length;
                }
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth >= Dimensions.mobileWidth) {
                      return Column(
                        children: [
                          _labresultTile(dataToShow, dataLength),

                          // _buildList(snapshot, dataToShow, widget.index),
                          _tabletView(snapshot),
                        ],
                      );
                    } else {
                      return _mobileView(snapshot);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ListView _labresultTile(List<Labresult> dataToShow, int dataLength) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(), 
      itemCount: dataLength,
      itemBuilder: (context, index) { 
        return _buildList(dataToShow[index]);
      },
    );
  }

  Widget _buildList(Labresult list) {
    final jsonList = list.jsonTables;
    int numLabTypes = 0;
    for (numLabTypes; numLabTypes < jsonList!.length; numLabTypes++)
      print('COUNT NUMBER OF DATA $numLabTypes');

    // if (list.jsonTables!.isEmpty)
    //   return Builder(builder: (context) {
    //     return ListTile(
    //         onTap: () => Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => SubCategory(
    //                       name: list.title,
    //                     ))),
    //         leading: SizedBox(),
    //         title: Text(list.patient));
    //   });
    return ExpansionTile(
      title: Text(
        list.title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: List.generate(
        numLabTypes - 1,
        (index) => Text(jsonList[index + 1].toString()),
      ),
    );
  }

  GridView _mobileView(AsyncSnapshot<List<Labresult>> snapshot) {
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

  GridView _tabletView(AsyncSnapshot<List<Labresult>> snapshot) {
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
