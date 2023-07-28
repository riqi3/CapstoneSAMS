import 'package:flutter/material.dart';
import '../../../../../models/PatientModel.dart';
import '../../../../../theme/Pallete.dart';

class PatientInfoCard extends StatefulWidget {
  final Patient patient;
  const PatientInfoCard({super.key, required this.patient});

  @override
  State<PatientInfoCard> createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 40),
            width: MediaQuery.of(context).size.width,
            height: 100,
            color: Pallete.mainColor,
            child: Text(
              'Patient Information',
              style: TextStyle(
                  color: Pallete.whiteColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 2),
              children: [
                TableRow(children: [
                  Column(
                    children: [
                      Text(
                        '${widget.patient.firstName}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${widget.patient.age}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ])
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 40),
            width: MediaQuery.of(context).size.width,
            height: 100,
            color: Pallete.whiteColor,
          ),
        ],
      ),
    );
  }
}
