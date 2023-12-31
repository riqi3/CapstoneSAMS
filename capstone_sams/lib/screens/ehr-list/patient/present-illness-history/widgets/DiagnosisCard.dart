import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiagnosisCard extends StatefulWidget {
  const DiagnosisCard({super.key});

  @override
  State<DiagnosisCard> createState() => _DiagnosisCardState();
}

class _DiagnosisCardState extends State<DiagnosisCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: Sizing.sectionSymmPadding),
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
                "Dr. Doe's Diagnoses",
                style: TextStyle(
                    height: 1,
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
                  bottom: Sizing.sectionSymmPadding,
                ),
                child: Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
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
                                'Pneumonia',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '12/21/2023',
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: popupActionWidget(index),
                        ),
                      );
                    },
                  ),
                ),

                // PhysicianCard(
                //   patient: widget.patient,
                // ),
              ),
            ),
          ],
        ),
      ),
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
