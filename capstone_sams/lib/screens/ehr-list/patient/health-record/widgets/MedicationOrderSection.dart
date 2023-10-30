import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/PhysicianCard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../constants/theme/pallete.dart';
import '../../../../../constants/theme/sizing.dart';

class MedicationOrderSection extends StatefulWidget {
  final Patient patient;
  // final VoidCallback press;
  const MedicationOrderSection({
    super.key,
    required this.patient,
    // required this.press,
  });

  @override
  State<MedicationOrderSection> createState() => _MedicationOrderSectionState();
}

class _MedicationOrderSectionState extends State<MedicationOrderSection> {
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
          padding: EdgeInsets.symmetric(horizontal: Sizing.sectionSymmPadding),
          width: MediaQuery.of(context).size.width,
          height: Sizing.cardContainerHeight,
          child: Text(
            'Physician Orders',
            style: TextStyle(
                color: Pallete.whiteColor,
                fontSize: Sizing.header3,
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
              // vertical: Sizing.sectionSymmPadding * 2,
              left: Sizing.sectionSymmPadding,
              right: Sizing.sectionSymmPadding,
              bottom: Sizing.sectionSymmPadding,
            ),
            child: PhysicianCard(patient: widget.patient),
          ),
        ),
      ],
    );
  }
}
