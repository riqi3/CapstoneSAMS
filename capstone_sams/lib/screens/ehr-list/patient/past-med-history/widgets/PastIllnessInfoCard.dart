import 'package:capstone_sams/global-widgets/cards/CardSectionInfoWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardTemplate.dart';
import 'package:capstone_sams/global-widgets/cards/CardTitleWidget.dart';
import 'package:capstone_sams/global-widgets/loading-indicator/CardContentLoading.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionTitleWidget.dart';
import 'package:capstone_sams/global-widgets/texts/RichTextTemplate.dart';
import 'package:capstone_sams/global-widgets/texts/TitleValueText.dart';
import 'package:capstone_sams/models/MedicalRecordModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicalRecordProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          return Center(child: CardContentLoading());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final MedicalRecord medicalRecord = snapshot.data!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Container(
              width: MediaQuery.of(context).size.width + 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichTextTemplate(
                    title: 'Past Diseases: ',
                    content: '${medicalRecord.pastDiseases}',
                  ),
                  SizedBox(height: Sizing.formSpacing),
                  RichTextTemplate(
                    title: 'Family History: ',
                    content: '${medicalRecord.familyHistory}',
                  ),
                  SizedBox(height: Sizing.formSpacing),
                  RichTextTemplate(
                    title: 'Allergies: ',
                    content: '${medicalRecord.allergies}',
                  ),
                  SizedBox(height: Sizing.formSpacing),
                  RichTextTemplate(
                    title: 'Illnesses: ',
                    content: '${medicalRecord.illnesses}',
                  ),
                  LMPData(medicalRecord),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Row PastDiseasesData(BuildContext context, MedicalRecord medicalRecord) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Diseases: ',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1,
          child: Text(
            '${medicalRecord.pastDiseases}',
          ),
        ),
      ],
    );
  }

  Row FamilyHistoryData(BuildContext context, MedicalRecord medicalRecord) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family History: ',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1,
          child: Text(
            '${medicalRecord.familyHistory}',
          ),
        ),
      ],
    );
  }

  Row AllergiesData(BuildContext context, MedicalRecord medicalRecord) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allergies: ',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1,
          child: Text(
            '${medicalRecord.allergies}',
          ),
        ),
      ],
    );
  }

  Row IllnessesData(BuildContext context, MedicalRecord medicalRecord) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Illnesses: ',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1,
          child: Text(
            '${medicalRecord.illnesses}',
          ),
        ),
      ],
    );
  }

  Row LMPData(MedicalRecord medicalRecord) {
    return Row(
      children: [
        Text(
          'Last Menstrual Period: ',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        if (widget.patient.gender == 'F')
          Text('${medicalRecord.lastMensPeriod}'),
      ],
    );
  }
}
