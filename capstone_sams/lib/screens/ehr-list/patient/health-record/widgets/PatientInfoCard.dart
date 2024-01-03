import 'package:capstone_sams/global-widgets/separators/DividerWidget.dart';
import 'package:capstone_sams/global-widgets/texts/CardSectionTitle.dart';
import 'package:capstone_sams/global-widgets/texts/TitleValueText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../constants/theme/pallete.dart';
import '../../../../../constants/theme/sizing.dart';
import '../../../../../models/PatientModel.dart';

class PatientInfoCard extends StatefulWidget {
  final Patient patient;
  const PatientInfoCard({super.key, required this.patient});

  @override
  State<PatientInfoCard> createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  String course() {
    String course = '';
    if (widget.patient.course == 'Nursery') {
      course = 'Nursery';
    }

    if (widget.patient.course == 'Kindergarten') {
      course = 'Kindergarten';
    }

    if (widget.patient.course == 'Elementary' ||
        widget.patient.course == 'Junior High School' ||
        widget.patient.course == 'Senior High School') {
      course = 'Grade';
    }

    if (widget.patient.course == 'Tertiary') {
      course = '${widget.patient.course}';
    }

    if (widget.patient.course == 'Law School') {
      course = '${widget.patient.course}';
    }

    return course;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Sizing.sectionSymmPadding),
      child: Material(
        elevation: Sizing.cardElevation,
        borderRadius: BorderRadius.all(
          Radius.circular(Sizing.borderRadius),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Pallete.mainColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Sizing.borderRadius),
                    topLeft: Radius.circular(Sizing.borderRadius)),
              ),
              alignment: Alignment.centerLeft,
              padding:
                  EdgeInsets.symmetric(horizontal: Sizing.sectionSymmPadding),
              width: MediaQuery.of(context).size.width,
              height: Sizing.cardContainerHeight,
              child: Text(
                'Patient Information',
                style: TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: Sizing.header3,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SectionTitleWidget(
              title: 'General Information',
            ),
            Material(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Sizing.borderRadius),
                  bottomRight: Radius.circular(Sizing.borderRadius)),
              child: Container(
                width: MediaQuery.of(context).size.width + 10,
                decoration: BoxDecoration(
                  color: Pallete.whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(Sizing.borderRadius),
                      bottomLeft: Radius.circular(Sizing.borderRadius)),
                ),
                padding: const EdgeInsets.only(
                  left: Sizing.sectionSymmPadding,
                  right: Sizing.sectionSymmPadding,
                  bottom: Sizing.sectionSymmPadding,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            '${widget.patient.firstName} ${widget.patient.middleInitial}. ${widget.patient.lastName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Sizing.header5,
                            ),
                          ),
                        ],
                      ),
                      Table(
                        columnWidths: <int, TableColumnWidth>{
                          0: FixedColumnWidth(Sizing.columnWidth4),
                          1: FixedColumnWidth(Sizing.columnWidth3),
                        },
                        children: [
                          TableRow(
                            children: <Widget>[
                              Container(
                                padding:
                                    EdgeInsets.only(right: Sizing.formSpacing),
                                child: TitleValueText(
                                  title: 'Student No#: ',
                                  value: '${widget.patient.studNumber}',
                                ),
                              ),
                              TitleValueText(
                                title: 'Course/Year: ',
                                value: '${course()} ${widget.patient.yrLevel}',
                              ),
                            ],
                          ),
                        ],
                      ),
                      Table(
                        columnWidths: <int, TableColumnWidth>{
                          0: FixedColumnWidth(Sizing.columnWidth4),
                          1: FixedColumnWidth(Sizing.columnWidth2),
                          2: FixedColumnWidth(Sizing.columnWidth2),
                        },
                        children: [
                          TableRow(
                            children: <Widget>[
                              Container(
                                padding:
                                    EdgeInsets.only(right: Sizing.formSpacing),
                                child: TitleValueText(
                                  title: 'Birthdate: ',
                                  value:
                                      '${DateFormat.yMMMd('en_US').format(widget.patient.birthDate)}',
                                ),
                              ),
                              TitleValueText(
                                title: 'Age: ',
                                value: '${widget.patient.age}',
                              ),
                              TitleValueText(
                                title: 'Sex: ',
                                value: '${widget.patient.gender}',
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              TitleValueText(
                                title: 'Height: ',
                                value: '${widget.patient.height}',
                              ),
                              TitleValueText(
                                title: 'Weight: ',
                                value: '${widget.patient.weight}',
                              ),
                              TitleValueText(
                                title: 'Status: ',
                                value: 'UPDATE',
                              ),
                            ],
                          ),
                        ],
                      ),
                      Table(
                        columnWidths: <int, TableColumnWidth>{
                          0: FixedColumnWidth(Sizing.columnWidth4),
                          1: FixedColumnWidth(Sizing.columnWidth5),
                        },
                        children: [
                          TableRow(
                            children: <Widget>[
                              TitleValueText(
                                title: 'Contact No#: ',
                                value: '${widget.patient.phone}',
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(right: Sizing.formSpacing),
                                child: TitleValueText(
                                  title: 'Email: ',
                                  value: '${widget.patient.email}',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1,
                                child: Text(
                                  '${widget.patient.address} a sadas sa asdsasssss  ssssssss  sssss  sssaaaaaaaaaassssdasds dadsadsdsasdas  asdds',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SectionTitleWidget(
              title: 'Emergency Contact Information',
            ),
            Material(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Sizing.borderRadius),
                  bottomRight: Radius.circular(Sizing.borderRadius)),
              child: Container(
                width: MediaQuery.of(context).size.width + 10,
                decoration: BoxDecoration(
                  color: Pallete.whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(Sizing.borderRadius),
                      bottomLeft: Radius.circular(Sizing.borderRadius)),
                ),
                padding: const EdgeInsets.only(
                  left: Sizing.sectionSymmPadding,
                  right: Sizing.sectionSymmPadding,
                  bottom: Sizing.sectionSymmPadding,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            '${widget.patient.firstName} ${widget.patient.middleInitial}. ${widget.patient.lastName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Sizing.header5,
                            ),
                          ),
                        ],
                      ),
                      Table(
                        columnWidths: <int, TableColumnWidth>{
                          0: FixedColumnWidth(Sizing.columnWidth4),
                          1: FixedColumnWidth(Sizing.columnWidth3),
                        },
                        children: [
                          TableRow(
                            children: <Widget>[
                              Container(
                                padding:
                                    EdgeInsets.only(right: Sizing.formSpacing),
                                child: TitleValueText(
                                  title: 'Student No#: ',
                                  value: '${widget.patient.studNumber}',
                                ),
                              ),
                              TitleValueText(
                                title: 'Course/Year: ',
                                value: '${course()} ${widget.patient.yrLevel}',
                              ),
                            ],
                          ),
                        ],
                      ),
                      Table(
                        columnWidths: <int, TableColumnWidth>{
                          0: FixedColumnWidth(Sizing.columnWidth4),
                          1: FixedColumnWidth(Sizing.columnWidth2),
                          2: FixedColumnWidth(Sizing.columnWidth2),
                        },
                        children: [
                          TableRow(
                            children: <Widget>[
                              Container(
                                padding:
                                    EdgeInsets.only(right: Sizing.formSpacing),
                                child: TitleValueText(
                                  title: 'Birthdate: ',
                                  value:
                                      '${DateFormat.yMMMd('en_US').format(widget.patient.birthDate)}',
                                ),
                              ),
                              TitleValueText(
                                title: 'Age: ',
                                value: '${widget.patient.age}',
                              ),
                              TitleValueText(
                                title: 'Sex: ',
                                value: '${widget.patient.gender}',
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              TitleValueText(
                                title: 'Height: ',
                                value: '${widget.patient.height}',
                              ),
                              TitleValueText(
                                title: 'Weight: ',
                                value: '${widget.patient.weight}',
                              ),
                              TitleValueText(
                                title: 'Status: ',
                                value: 'UPDATE',
                              ),
                            ],
                          ),
                        ],
                      ),
                      Table(
                        columnWidths: <int, TableColumnWidth>{
                          0: FixedColumnWidth(Sizing.columnWidth4),
                          1: FixedColumnWidth(Sizing.columnWidth5),
                        },
                        children: [
                          TableRow(
                            children: <Widget>[
                              TitleValueText(
                                title: 'Contact No#: ',
                                value: '${widget.patient.phone}',
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(right: Sizing.formSpacing),
                                child: TitleValueText(
                                  title: 'Email: ',
                                  value: '${widget.patient.email}',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1,
                                child: Text(
                                  '${widget.patient.address} a sadas sa asdsasssss  ssssssss  sssss  sssaaaaaaaaaassssdasds dadsadsdsasdas  asdds',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
