import 'package:flutter/material.dart';
import '../../../../../constants/theme/pallete.dart';
import '../../../../../constants/theme/sizing.dart';
import '../../../../../models/PatientModel.dart';

class PatientInfoCard extends StatefulWidget {
  final Patient patient;
  const PatientInfoCard({super.key, required this.patient});

  @override
  State<PatientInfoCard> createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  final titles = [
    'Patient ID',
    'First Name',
    'Middle Initial',
    'Last Name',
    'Age',
    'Gender',
    'Birthdate',
    'Department',
    'Course',
    'Year Level',
    'Student Number',
    'Address',
    'Height',
    'Weight',
    'Phone',
    'Email',
    'Assigned Physician'
  ];
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
              padding: EdgeInsets.all(Sizing.sectionSymmPadding),
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
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Sizing.borderRadius),
                  bottomRight: Radius.circular(Sizing.borderRadius)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Pallete.whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(Sizing.borderRadius),
                      bottomLeft: Radius.circular(Sizing.borderRadius)),
                ),
                padding: const EdgeInsets.only(
                  left: Sizing.sectionSymmPadding,
                  right: Sizing.sectionSymmPadding,
                  bottom: Sizing.sectionSymmPadding,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('TITLE')),
                      DataColumn(label: Text('VALUE')),
                    ],
                    rows: List<DataRow>.generate(
                      widget.patient.toJson().entries.length,
                      (int index) {
                        MapEntry entry =
                            widget.patient.toJson().entries.elementAt(index);
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(titles[index])),
                            DataCell(Text(entry.value.toString())),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
