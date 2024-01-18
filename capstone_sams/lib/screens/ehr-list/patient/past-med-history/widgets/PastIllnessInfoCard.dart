import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/global-widgets/separators/DividerWidget.dart';
import 'package:capstone_sams/global-widgets/texts/CardSectionTitle.dart';
import 'package:capstone_sams/global-widgets/texts/TitleValueText.dart';
import 'package:capstone_sams/models/ContactPersonModel.dart';
import 'package:capstone_sams/models/MedicalRecordModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/ContactPersonProvider.dart';
import 'package:capstone_sams/providers/MedicalRecordProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants/theme/pallete.dart';
import '../../../../../../constants/theme/sizing.dart';
import '../../../../../../models/PatientModel.dart';

class PastIllnesInfoCard extends StatefulWidget {
  final Patient patient;
  const PastIllnesInfoCard({super.key, required this.patient});

  @override
  State<PastIllnesInfoCard> createState() => _PastIllnesInfoCardState();
}

class _PastIllnesInfoCardState extends State<PastIllnesInfoCard> {
  late Stream<List<MedicalRecord>> medicalRecord;
  late String token = context.read<AccountProvider>().token!;

  @override
  void initState() {
    super.initState();
    token = context.read<AccountProvider>().token!;
  }

  @override
  Widget build(BuildContext context) {
    MedicalRecordProvider medicalRecordProvider =
        Provider.of<MedicalRecordProvider>(context);

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
                'Medical Information',
                style: TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: Sizing.header3,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SectionTitleWidget(
              title: 'adca Information',
            ),
            Material(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Sizing.borderRadius),
                  bottomRight: Radius.circular(Sizing.borderRadius)),
              child: Container(
                width: MediaQuery.of(context).size.width + 10,
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
                child: FutureBuilder<MedicalRecord>(
                  future: medicalRecordProvider.fetchMedicalRecords(
                      token, widget.patient.patientID),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final MedicalRecord medicalRecord = snapshot.data!;
                      print('address ${medicalRecord.allergies}');

                      return ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [Colors.black, Colors.transparent],
                            stops: [0.95, 1],
                          ).createShader(bounds);
                        },
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(
                                    '${medicalRecord.allergies}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Sizing.header5,
                                    ),
                                  ),
                                ],
                              ),
                              Table(
                                columnWidths: <int, TableColumnWidth>{
                                  0: FixedColumnWidth(Sizing.columnWidth4),
                                },
                                children: [
                                  TableRow(
                                    children: <Widget>[
                                      TitleValueText(
                                        title: 'Contact No#: ',
                                        value: '${medicalRecord.familyHistory}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        child: Text(
                                          '${medicalRecord.illnesses}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
