// ignore_for_file: prefer_const_constructors

import 'package:capstone_sams/models/patient.dart';
import 'package:capstone_sams/screens/patient-record/PatientRecordScreen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_sams/theme/pallete.dart';
import 'package:intl/intl.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;

  PatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PatientRecordScreen(),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ListTile(
              title: Text(
                'Hospital No. ${patient.patientId}',
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
                    "${patient.firstName} ${patient.middleName != null ? patient.middleName![0] + '.' : ''} ${patient.middleName == null ? '' + patient.lastName : patient.lastName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Pallete.textColor,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    children: [
                      Text('Sex: ${patient.gender}'),
                      SizedBox(width: 16.0),
                      Text('Age: ${patient.age}'),
                      SizedBox(width: 16.0),
                      Text(
                          'Birthdate: ${DateFormat.yMMMd('en_US').format(patient.birthDate)}'),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Date of Registration: ${DateFormat.yMMMd('en_US').format(patient.registration)}',
                    style: TextStyle(
                      color: Pallete.mainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
