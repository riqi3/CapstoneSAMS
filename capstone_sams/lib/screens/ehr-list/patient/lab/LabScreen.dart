import 'package:capstone_sams/providers/LabResultProvider.dart';

import 'package:capstone_sams/screens/ehr-list/patient/lab/widgets/LabresultCard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: dataLength,
                      itemBuilder: (context, index) {
                        return _buildList(
                          // snapshot,
                          // dataToShow,
                          dataToShow[index],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(Labresult list) {
    final jsonList = list.jsonTables;
    final labresultTitles = list.labresultTitles;
    final collectedOn = list.collectedOn;
    final String formattedDate = DateFormat.yMMMMd().format(collectedOn);

    if (jsonList == null || labresultTitles == null) {
      return Container();
    }

    int numLabTypes = (labresultTitles.length);
    print('COUNT NUMBER OF DATA $numLabTypes');

    return ExpansionTile(
      textColor: Colors.amber,
      title: Text(
        ('${formattedDate} | ${list.title}'),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    
      // trailing: FaIcon(FontAwesomeIcons.chevronDown),
      subtitle: GestureDetector(
        onTap: () {
          print('ss');
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(Sizing.sectionSymmPadding),
                child: Text(
                  ('Investigations: ${list.comment}'),
                  style: TextStyle(fontSize: Sizing.header5),
                ),
              ),
            ),
          );
        },
        child: Text(
          ('Investigations: ${list.comment}'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      children: List.generate(numLabTypes, (index) {
        print('aa');
        return ListTile(
          title: Text(labresultTitles[index]),
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                alignment: Alignment.center,
                child: LabResultCard(
                  labresult: list,
                  a: index + 1,
                ),
              ),
            );
          },
        );
      }),
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
