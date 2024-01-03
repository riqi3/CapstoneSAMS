import 'package:capstone_sams/global-widgets/separators/DividerWidget.dart';
import 'package:capstone_sams/global-widgets/texts/TitleValueText.dart';
import 'package:capstone_sams/screens/ehr-list/patient/PatientTabsScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../constants/theme/pallete.dart';
import '../../../constants/theme/sizing.dart';
import '../../../models/PatientModel.dart';

class PatientCard extends StatefulWidget {
  final Patient patient;
  final int labresult;
  PatientCard({
    required this.patient,
    required this.labresult,
  });

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientTabsScreen(
              patient: widget.patient,
              index: widget.labresult,
            ),
          ),
        );
      },
      child: Card(
        elevation: Sizing.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizing.borderRadius),
        ),
        child: Container(
          padding: EdgeInsets.all(Sizing.padding - 5),
          child: Wrap(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.patient.firstName}  ${widget.patient.middleInitial}. ${widget.patient.lastName}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Sizing.header4,
                              color: Pallete.textColor,
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     print('object');
                          //   },
                          //   icon: FaIcon(FontAwesomeIcons.phone),
                          // ),
                        ],
                      ),
                      TitleValueText(
                        title: 'Student No#: ',
                        value: '${widget.patient.studNumber}',
                      ),
                      Row(
                        children: [
                          TitleValueText(
                            title: 'Course/Year: ',
                            value: '${course()} ${widget.patient.yrLevel}',
                          ),
                        ],
                      ),
                      // SizedBox(height: Sizing.spacing),
                      Row(
                        children: [
                          TitleValueText(
                            title: 'Birthdate: ',
                            value:
                                '${DateFormat.yMMMd('en_US').format(widget.patient.birthDate)}',
                          ),
                          SizedBox(width: Sizing.textSizeAppBar),
                          TitleValueText(
                            title: 'Age: ',
                            value: '${widget.patient.age}',
                          ),
                          SizedBox(width: Sizing.textSizeAppBar),
                          TitleValueText(
                            title: 'Sex: ',
                            value: '${widget.patient.gender}',
                          ),
                        ],
                      ),
                      DividerWidget(),
                      // SizedBox(height: Sizing.spacing),
                      // Text(
                      //   'Date of Registration: ${DateFormat.yMMMd('en_US').format(widget.patient.registration)}',
                      //   style: TextStyle(
                      //     color: Pallete.mainColor,
                      //   ),
                      // ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Present Illness: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              'ssssssssss s sss ss sssss s ss s sssssssss s ss wss s',
                              style: TextStyle(
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // TitleValueText(
                      //   title: 'Present Illness: ',
                      //   value: 'ssssssssssss s ss s sssssssss s ss wss s',
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
