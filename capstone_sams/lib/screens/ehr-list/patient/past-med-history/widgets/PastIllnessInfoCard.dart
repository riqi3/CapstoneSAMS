import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionInfoWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardTemplate.dart';
import 'package:capstone_sams/global-widgets/cards/CardTitleWidget.dart';
import 'package:capstone_sams/global-widgets/separators/DividerWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionTitleWidget.dart';
import 'package:capstone_sams/global-widgets/texts/TitleValueText.dart';
import 'package:capstone_sams/models/ContactPersonModel.dart';
import 'package:capstone_sams/models/MedicalRecordModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/ContactPersonProvider.dart';
import 'package:capstone_sams/providers/MedicalRecordProvider.dart';
import 'package:capstone_sams/providers/PatientProvider.dart';
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

    return CardTemplate(
      column: Column(
        children: [
          CardTitleWidget(title: 'Medical Information'),
          CardSectionTitleWidget(title: 'Past Medical History'),
          CardSectionInfoWidget(
            widget: MedicalRecordData(medicalRecordProvider),
          ),
        ],
      ),
    );
  }

  FutureBuilder<MedicalRecord> MedicalRecordData(
      MedicalRecordProvider medicalRecordProvider) {
    return FutureBuilder<MedicalRecord>(
      future: medicalRecordProvider.fetchMedicalRecords(
          token, widget.patient.patientID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final MedicalRecord medicalRecord = snapshot.data!;

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
                      if (widget.patient.gender == 'F')
                        Text('${medicalRecord.lastMensPeriod}'),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1,
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
    );
  }
}
