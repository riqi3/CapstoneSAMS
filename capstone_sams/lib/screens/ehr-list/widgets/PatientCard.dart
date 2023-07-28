import 'package:capstone_sams/screens/ehr-list/patient/health-record/PatientTabsScreen.dart';
import 'package:capstone_sams/theme/sizing.dart';
import 'package:flutter/material.dart';
import 'package:capstone_sams/theme/pallete.dart';
import 'package:intl/intl.dart';
import '../../../models/PatientModel.dart';

class PatientCard extends StatefulWidget {
  final Patient patient;

  PatientCard({
    required this.patient,
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
            builder: (context) => PatientTabsScreen(patient: widget.patient),
          ),
        );
      },
      child: Card(
        elevation: Sizing.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizing.borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(
                'Hospital No. ${widget.patient.patientId}',
                style: TextStyle(
                  color: Pallete.mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    "${widget.patient.firstName}  ${widget.patient.middleName != null ? widget.patient.middleName![0] + '.' : ''} ${widget.patient.middleName == null ? '' + widget.patient.lastName : widget.patient.lastName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Pallete.textColor,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    children: [
                      Text('Sex: ${widget.patient.gender}'),
                      SizedBox(width: 16.0),
                      Text('Age: ${widget.patient.age}'),
                      SizedBox(width: 16.0),
                      Text(
                          'Birthdate: ${DateFormat.yMMMd('en_US').format(widget.patient.birthDate)}'),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Date of Registration: ${DateFormat.yMMMd('en_US').format(widget.patient.registration)}',
                    style: TextStyle(
                      color: Pallete.mainColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
