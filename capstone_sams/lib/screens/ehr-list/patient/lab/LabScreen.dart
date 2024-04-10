import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionInfoWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardTemplate.dart';
import 'package:capstone_sams/global-widgets/cards/CardTitleWidget.dart';
import 'package:capstone_sams/global-widgets/loading-indicator/DiagnosisCardLoading.dart';
import 'package:capstone_sams/global-widgets/scaffolds/ScaffoldTemplate.dart';
import 'package:capstone_sams/global-widgets/texts/NoDataTextWidget.dart';
import 'package:capstone_sams/providers/LabResultProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/lab/widgets/LabresultCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../constants/Strings.dart';
import '../../../../constants/theme/sizing.dart';
import '../../../../models/LabResultModel.dart';

class LaboratoriesScreen extends StatefulWidget {
  final String? index;
  const LaboratoriesScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

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
    return ScaffoldTemplate(
      column: Column(
        children: [
          CardTemplate(
            column: Column(
              children: [
                CardTitleWidget(title: 'Past Laboratories'),
                SizedBox(height: Sizing.sectionSymmPadding),
                CardSectionInfoWidget(
                  widget: LaboratoriesData(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<Labresult>> LaboratoriesData() {
    return FutureBuilder(
      future: labresults,
      builder: (context, snapshot) {
        List<Labresult> dataToShow = [];
        int dataLength = 0;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: ListCardLoading());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Container(
              height: 100,
              child: Center(
                child: NoDataTextWidget(
                  text: Strings.noLabResults,
                ),
              ),
            ),
          );
        } else {
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
                  dataToShow[index],
                );
              },
            );
          },
        );
      },
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

    return ExpansionTile(
      textColor: Pallete.mainColor,
      iconColor: Pallete.mainColor,
      collapsedIconColor: Pallete.greyColor,
      title: Text(
        ('${formattedDate} | ${list.title}'),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(Sizing.sectionSymmPadding),
                child: Text(
                  ('Investigations:\n\n${list.investigation}'),
                  style: TextStyle(fontSize: Sizing.header5),
                ),
              ),
            ),
          );
        },
        child: Text(
          ('Investigations:\n${list.investigation}'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      children: List.generate(numLabTypes, (index) {
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
                  labresultTitles: labresultTitles[index],
                  labresult: list,
                  index: index + 1,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
