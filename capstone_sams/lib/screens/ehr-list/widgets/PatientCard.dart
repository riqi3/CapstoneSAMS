import 'package:capstone_sams/global-widgets/texts/TitleValueText.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/PatientTabsScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/theme/pallete.dart';
import '../../../constants/theme/sizing.dart';
import '../../../models/PatientModel.dart';

// ignore: must_be_immutable
class PatientCard extends StatefulWidget {
  final Patient patient;
  Account? account;
  final Function(String)? callback;
  final Function(String) onSelect;
  final String? labresult;
  PatientCard({
    required this.patient,
    required this.onSelect,
    this.account,
    this.callback,
    required this.labresult,
  });

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  late PresentIllness? presentIllness =
      context.read<PresentIllnessProvider>().presentIllness;

  String department() {
    String department = '';
    if (widget.patient.department == 'Nursery') {
      department = 'Nursery';
    }

    if (widget.patient.department == 'Kindergarten') {
      department = 'Kindergarten';
    }

    if (widget.patient.department == 'Elementary' ||
        widget.patient.department == 'Junior High School' ||
        widget.patient.department == 'Senior High School') {
      department = 'Grade';
    }

    if (widget.patient.department == 'Tertiary') {
      department = '${widget.patient.department}';
    }

    if (widget.patient.department == 'Law School') {
      department = '${widget.patient.department}';
    }

    return department;
  }

  Map<String, int> calculateAge(DateTime currentDate, DateTime birthDate) {
    int years = currentDate.year - birthDate.year;
    int months = currentDate.month - birthDate.month;
    int days = currentDate.day - birthDate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += (months < 0 ? 12 : 0);
    }

    if (days < 0) {
      final daysInPreviousMonth =
          DateTime(currentDate.year, currentDate.month - 1, 0).day;
      days += daysInPreviousMonth;
      months--;
    }

    return {'years': years, 'months': months, 'days': days};
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    DateTime originalDate1 = DateTime.parse(widget.patient.birthDate!);
    final age = calculateAge(currentDate, originalDate1);
    String birthDate = DateFormat('MMM d, y').format(originalDate1);

    return GestureDetector(
      onTap: () {
        widget.onSelect(widget.patient.patientID as String);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientTabsScreen(
              patient: widget.patient,
              index: widget.patient.patientID,
              selectedPage: 0,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.patient.firstName?.toUpperCase()} ${widget.patient.middleInitial?.toUpperCase()}. ${widget.patient.lastName?.toUpperCase()}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Sizing.header4,
                            color: Pallete.textColor,
                          ),
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
                  Row(
                    children: [
                      Text(
                        'Student No#: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Pallete.textColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${widget.patient.studNumber}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Pallete.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TitleValueText(
                        title: 'Dept: ',
                        value: '${widget.patient.department}',
                      ),
                      SizedBox(width: Sizing.sectionSymmPadding),
                      TitleValueText(
                        title: 'Year: ',
                        value: '${widget.patient.yrLevel}',
                      ),
                      SizedBox(width: Sizing.sectionSymmPadding),
                      TitleValueText(
                        title: 'Sex: ',
                        value: '${widget.patient.gender}',
                      ),
                    ],
                  ),
                  // SizedBox(height: Sizing.spacing),
                  Row(
                    children: [
                      TitleValueText(
                        title: 'Birthdate: ',
                        value: '${birthDate}',
                      ),
                      SizedBox(width: Sizing.textSizeAppBar),
                      TitleValueText(
                        title: 'Age: ',
                        value: '${age['years']}y',
                      ),
                    ],
                  ),
                  // DividerWidget(),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Present Illness: ',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     Container(
                  //       width: MediaQuery.of(context).size.width / 2,
                  //       child: Text(
                  //         ('$dataFromChild'),
                  //         style: TextStyle(
                  //           height: 1.2,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // TitleValueText(
                  //   title: 'Present Illness: ',
                  //   value: 'ssssssssssss s ss s sssssssss s ss wss s',
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
