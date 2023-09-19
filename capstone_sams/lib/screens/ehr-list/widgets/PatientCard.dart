import 'dart:convert';

import 'package:capstone_sams/models/LabResultModel.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/PatientTabsScreen.dart';
import 'package:capstone_sams/theme/sizing.dart';
import 'package:flutter/material.dart';
import 'package:capstone_sams/theme/pallete.dart';
import 'package:intl/intl.dart';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.patient.firstName);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hospital No. ${widget.patient.patientId}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Pallete.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Sizing.header6,
                    ),
                  ),
                  SizedBox(height: Sizing.spacing),
                  Text(
                    "${widget.patient.firstName}  ${widget.patient.middleName != null ? widget.patient.middleName![0] + '.' : ''} ${widget.patient.middleName == null ? '' + widget.patient.lastName : widget.patient.lastName}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Sizing.header4,
                      color: Pallete.textColor,
                    ),
                  ),
                  SizedBox(height: Sizing.spacing),
                  Row(
                    children: [
                      Text('Sex: ${widget.patient.gender}'),
                      SizedBox(width: Sizing.spacing),
                      Text('Age: ${widget.patient.age}'),
                      SizedBox(width: Sizing.spacing),
                      Flexible(
                        child: Text(
                          'Birthdate: ${DateFormat.yMMMd('en_US').format(widget.patient.birthDate)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Sizing.spacing),
                  Text(
                    'Date of Registration: ${DateFormat.yMMMd('en_US').format(widget.patient.registration)}',
                    style: TextStyle(
                      color: Pallete.mainColor,
                    ),
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
