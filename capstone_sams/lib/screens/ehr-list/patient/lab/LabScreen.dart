import 'package:capstone_sams/providers/LabResultProvider.dart';

import 'package:capstone_sams/screens/ehr-list/patient/lab/widgets/LabresultCard.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

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
                    return _labresultTile(
                        // snapshot,
                        dataToShow,
                        dataLength);
                    // if (constraints.maxWidth >= Dimensions.mobileWidth) {
                    //   return Column(
                    //     children: [
                    //       _labresultTile(snapshot, dataToShow, dataLength),

                    //       // _buildList(snapshot, dataToShow, widget.index),
                    //       _tabletView(snapshot),
                    //     ],
                    //   );
                    // } else {
                    //   return _mobileView(snapshot);
                    // }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ListView _labresultTile(
      // AsyncSnapshot<List<Labresult>> snapshot,
      List<Labresult> dataToShow,
      int dataLength) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: dataLength,
      itemBuilder: (context, index) {
        return _buildList(
          // snapshot,
          dataToShow,
          dataToShow[index],
        );
      },
    );
  }

  Widget _buildList(
      // AsyncSnapshot<List<Labresult>> snapshot,
      List<Labresult> s,
      Labresult list) {
    final jsonList = list.jsonTables;
    final labresultTitles = list.labresultTitles;

    if (jsonList == null || labresultTitles == null) {
      return Container(); // Handle null data gracefully
    }
    // int numLabTypes = 0;

    int numLabTypes = (jsonList.length);
    // for (numLabTypes; numLabTypes < jsonList.length; numLabTypes++) {
    print('COUNT NUMBER OF DATA $numLabTypes');
    // }

    // int numLabTypes = 0;
    // for (numLabTypes; numLabTypes < jsonList!.length; numLabTypes++)
    //   print('COUNT NUMBER OF DATA $numLabTypes');

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
        // list.labresultTitles![0],
        ('${list.createdAt.toIso8601String()} | ${list.title}'),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: List.generate(
        numLabTypes,
        (index)
            // {
            //   if (index < labresultTitles.length) {
            //     // print('number of laboratories ${numLabTypes}');
            //     // print('titles ${labresultTitles![index]}');
            //     return ListTile(
            //       onTap: () {
            //         // final labresult = s[index];
            //         Labresult? labresult = s[index];
            //         showDialog(
            //           context: context,
            //           builder: (context) => AlertDialog(
            //             content: LabResultCard(
            //               labresult: labresult,
            //               a: index,
            //             ),
            //           ),
            //         );
            //       },
            //       title: Text(labresultTitles[index].toString()),
            //     );
            //   } else {
            //     return ListTile(
            //       title: Text('Lab result not found for index $index'),
            //     );
            //   }
            // },

            =>
            ListTile(
          onTap: () {
            Labresult? labresult = s[index];
            print('number of laboratories ${numLabTypes}');
            print('titles ${labresultTitles[index]}');
            // print('labresult ${s[index]}');
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,

                alignment: Alignment.center,
                // contentPadding: EdgeInsets.zero,
                child: LabResultCard(
                  labresult: labresult,
                  a: numLabTypes - 1,
                ),
              ),
            );
          },
          title: Text(labresultTitles[1].toString()),
        ),

        // {
        //   return ListTile(
        //     onTap: () {
        //       Labresult? labresult = s[index];
        //       print('number of laboratories ${numLabTypes}');
        //       print('titles ${labresultTitles[index]}');
        //       // print('labresult ${s[index]}');
        //       showDialog(
        //         context: context,
        //         builder: (context) => AlertDialog(
        //           content: LabResultCard(
        //             labresult: labresult,
        //             a: numLabTypes - 1,
        //           ),
        //         ),
        //       );
        //     },
        //     title: Text(labresultTitles[index].toString()),
        //   );
        // },
      ),
    );
  }

  // GridView _mobileView(AsyncSnapshot<List<Labresult>> snapshot) {
  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: const BouncingScrollPhysics(),
  //     itemCount: snapshot.data?.length,
  //     itemBuilder: (context, index) {
  //       final labresult = snapshot.data![index];
  //       return LabResultCard(labresult: labresult);
  //     },
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 1,
  //       mainAxisSpacing: 10,
  //       crossAxisSpacing: 10,
  //       // childAspectRatio: 16 / 8,
  //     ),
  //   );
  // }

  // GridView _tabletView(AsyncSnapshot<List<Labresult>> snapshot) {
  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: const BouncingScrollPhysics(),
  //     itemCount: snapshot.data?.length,
  //     itemBuilder: (context, index) {
  //       final labresult = snapshot.data![index];
  //       return LabResultCard(labresult: labresult);
  //     },
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 1,
  //       mainAxisSpacing: 10,
  //       crossAxisSpacing: 10,
  //       // childAspectRatio: 16 / 10,
  //     ),
  //   );
  // }
}
