import 'package:capstone_sams/screens/ehr-list/patient/PatientTabsScreen.dart';
import 'package:flutter/material.dart';
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
          child: Wrap(children: [
            Column(
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
          ]),
        ),
      ),
    );
  }
}
