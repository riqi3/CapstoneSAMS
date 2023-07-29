import 'package:flutter/material.dart';
import '../../../../../models/PatientModel.dart';
import '../../../../../theme/Pallete.dart';
import '../../../../../theme/Sizing.dart';

class PatientInfoCard extends StatefulWidget {
  final Patient patient;
  const PatientInfoCard({super.key, required this.patient});

  @override
  State<PatientInfoCard> createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Pallete.mainColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(Sizing.borderRadius),
                topLeft: Radius.circular(Sizing.borderRadius)),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 40),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Text(
            'Patient Information',
            style: TextStyle(
                color: Pallete.whiteColor,
                fontSize: 40,
                fontWeight: FontWeight.w600),
          ),
        ),
        Material(
          elevation: Sizing.cardElevation,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Sizing.borderRadius),
              bottomRight: Radius.circular(Sizing.borderRadius)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(Sizing.borderRadius),
                  bottomLeft: Radius.circular(Sizing.borderRadius)),
            ),
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 50, top: 50),
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
        ),

        // Container(
        //   alignment: Alignment.centerLeft,
        //   padding: EdgeInsets.symmetric(horizontal: 40),
        //   width: MediaQuery.of(context).size.width,
        //   height: 100,
        //   color: Pallete.whiteColor,
        // ),
      ],
    );
  }
}
