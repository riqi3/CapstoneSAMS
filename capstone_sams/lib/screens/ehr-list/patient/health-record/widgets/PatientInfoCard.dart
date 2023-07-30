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
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: Sizing.sectionSymmPadding),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Pallete.whiteColor,
              ),
              child: Text(
                'General Information',
                style: TextStyle(
                    color: Pallete.mainColor,
                    fontSize: Sizing.header4,
                    fontWeight: FontWeight.w600),
              ),
            ),

            Material(
              // elevation: Sizing.cardElevation,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Sizing.borderRadius),
                  bottomRight: Radius.circular(Sizing.borderRadius)),
              child: Container(
                decoration: BoxDecoration(
                  color: Pallete.whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(Sizing.borderRadius),
                      bottomLeft: Radius.circular(Sizing.borderRadius)),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: Sizing.sectionSymmPadding * 2,
                  horizontal: Sizing.sectionSymmPadding,
                ),
                child: Table(
                  border: TableBorder.all(
                      color: Colors.black, style: BorderStyle.solid, width: 2),
                  children: [
                    TableRow(children: [
                      Column(
                        children: [
                          Text(
                            '${widget.patient.firstName}',
                            style: TextStyle(fontSize: Sizing.header4),
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
        ),
      ),
    );
  }
}
