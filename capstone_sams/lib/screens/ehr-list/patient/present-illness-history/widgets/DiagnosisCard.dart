import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionInfoWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionTitleWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardTemplate.dart';
import 'package:capstone_sams/global-widgets/cards/CardTitleWidget.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DiagnosisCard extends StatefulWidget {
  final Patient patient;
  DiagnosisCard({
    super.key,
    required this.patient,
  });

  @override
  State<DiagnosisCard> createState() => _DiagnosisCardState();
}

class _DiagnosisCardState extends State<DiagnosisCard> {
  late Stream<List<PresentIllness>> presentIllness;
  late String token = context.read<AccountProvider>().token!;
  @override
  void initState() {
    super.initState();
    token = context.read<AccountProvider>().token!;
  }

  @override
  Widget build(BuildContext context) {
    PresentIllnessProvider presentIllnessProvider =
        Provider.of<PresentIllnessProvider>(context);

    return CardTemplate(
      column: Column(
        children: [
          CardTitleWidget(title: 'Dr. ${widget.patient.assignedPhysician}'),
          CardSectionTitleWidget(title: 'ss'),
          CardSectionInfoWidget(
            widget: PresentIllnessData(presentIllnessProvider),
          ),
        ],
      ),
    );
  }

  FutureBuilder<PresentIllness> PresentIllnessData(
      PresentIllnessProvider presentIllnessProvider) {
    return FutureBuilder<PresentIllness>(
      future: presentIllnessProvider.fetchComplaints(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          final PresentIllness presentIllness = snapshot.data!;

          return Card(
            margin: EdgeInsets.symmetric(
              vertical: Sizing.sectionSymmPadding / 2,
              horizontal: Sizing.sectionSymmPadding,
            ),
            child: ListTile(
              title: Row(
                children: [
                  Text(
                    'Dx: ',
                  ),
                  Text(
                    '${presentIllness.illnessName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${presentIllness.created_at}',
                    // style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // trailing: popupActionWidget(presentIllness.),
            ),
          );
        }
      },
    );
  }

  PopupMenuButton<dynamic> popupActionWidget(int index) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.solidEye,
              color: Pallete.infoColor,
            ),
            title: Text(
              'View',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Pallete.infoColor,
              ),
            ),
            onTap: () {},
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.pen,
              color: Pallete.successColor,
            ),
            title: Text(
              'Edit',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Pallete.successColor,
              ),
            ),
            onTap: () {},
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.trash,
              color: Pallete.dangerColor,
            ),
            title: Text(
              'Delete',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Pallete.dangerColor,
              ),
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  PopupMenuButton<dynamic> nurseAction(
    int index,
    List<Prescription> prescriptionList,
    Prescription prescription,
  ) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.pills,
              color: Pallete.infoColor,
            ),
            title: Text(
              'Manage',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Pallete.infoColor,
              ),
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
