import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/SearchAppBar.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionInfoWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionTitleWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardTitleWidget.dart';
import 'package:capstone_sams/global-widgets/texts/TitleValueText.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:flutter/material.dart';

class ViewIllnessScreen extends StatefulWidget {
  final PresentIllness presentIllness;
  final String illnessIndex;
  const ViewIllnessScreen({
    super.key,
    required this.presentIllness,
    required this.illnessIndex,
  });

  @override
  State<ViewIllnessScreen> createState() => ViewIllnessScreenState();
}

class ViewIllnessScreenState extends State<ViewIllnessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizing.headerHeight),
        child: SearchAppBar(
          backgroundColor: Pallete.mainColor,
          iconColorLeading: Pallete.whiteColor,
          iconColorTrailing: Pallete.whiteColor,
        ),
      ),
      endDrawer: ValueDashboard(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: Sizing.sectionSymmPadding),
          child: Material(
            elevation: Sizing.cardElevation,
            borderRadius: BorderRadius.all(
              Radius.circular(Sizing.borderRadius),
            ),
            child: Column(
              children: [
                CardTitleWidget(title: 'Present Illness'),
                CardSectionTitleWidget(
                    title:
                        'Dx #${widget.illnessIndex} ${widget.presentIllness.illnessName}'),
                CardSectionInfoWidget( 
                  widget: PresentIllnessData(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView PresentIllnessData(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chief Complaint: ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  '${widget.presentIllness.complaint}',
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Findings: ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1,
                child: Text(
                  '${widget.presentIllness.findings}',
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Diagnosis: ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1,
                child: Text(
                  '${widget.presentIllness.diagnosis}',
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Treatment: ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1,
                child: Text(
                  '${widget.presentIllness.treatment}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PresentIllnessData extends StatelessWidget {
  const PresentIllnessData({
    super.key,
    required this.widget,
  });

  final ViewIllnessScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('${widget.presentIllness.illnessName}'),
      ],
    );
  }
}
