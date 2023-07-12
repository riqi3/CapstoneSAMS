// ignore_for_file: prefer_const_constructors

import 'package:capstone_sams/models/patient.dart';
import 'package:capstone_sams/screens/patient-record/PatientRecordScreen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_sams/theme/pallete.dart';

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
                'Hospital No. ${patient.id}',
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
                    patient.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Pallete.textColor,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    children: [
                      Text('Sex: ${patient.sex}'),
                      SizedBox(width: 16.0),
                      Text('Age: ${patient.age}'),
                      SizedBox(width: 16.0),
                      Flexible(
                        child: Text(
                          'Birthdate: ${patient.birthdate}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Date of Registration: ${patient.datereg}',
                    overflow: TextOverflow.ellipsis,
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
