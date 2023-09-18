import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/MedicationOrderSection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../models/PatientModel.dart';
import '../../../../../providers/AccountProvider.dart';
import '../../../../../providers/MedicineProvider.dart';
import '../../../../../theme/Pallete.dart';
import '../../../../../theme/Sizing.dart';
import '../../../../medical_notes/MedicalNotesScreen.dart';
import '../../order-entry/widgets/MedicineCard.dart';

class MedicationOrderCard extends StatefulWidget {
  final Patient patient;
  const MedicationOrderCard({super.key, required this.patient});

  @override
  State<MedicationOrderCard> createState() => _MedicationOrderCardState();
}

class _MedicationOrderCardState extends State<MedicationOrderCard> {
  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);
    final username = context.watch<AccountProvider>().username;
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
                'Physician\'s Orders',
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
                child: MedicationOrderSection(
                  physicianName: '$username',
                  // dateOrdered: dateOrdered,
                  press: () {
                    press(context, medicineProvider, username);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MedicalNotes(),
                    //   ),
                    // );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> press(
      BuildContext context, MedicineProvider medicineProvider, username) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * .85,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(Sizing.borderRadius),
            topRight: const Radius.circular(Sizing.borderRadius),
          ),
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
                'Order of $username',
                style: TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: Sizing.header3,
                    fontWeight: FontWeight.w600),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: medicineProvider.medicines.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.all(
                  Sizing.sectionSymmPadding / 2,
                ),
                child: MedicineCard(
                  medicine: medicineProvider.medicines[index],
                  index: index,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
