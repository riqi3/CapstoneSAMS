import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart'; 
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/global-widgets/forms/ChangePhysicianForm.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AssignDoctorCard extends StatefulWidget {
  const AssignDoctorCard({super.key});

  @override
  State<AssignDoctorCard> createState() => _AssignDoctorCardState();
}

class _AssignDoctorCardState extends State<AssignDoctorCard> { 
  late String token = context.read<AccountProvider>().token!;

  @override
  void initState() {
    super.initState();
  }

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
                'Assigned Physician/s',
                style: TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: Sizing.header3,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: Sizing.sectionSymmPadding,
                left: Sizing.sectionSymmPadding,
                right: Sizing.sectionSymmPadding,
              ),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Pallete.whiteColor,
              ),
              child: Text(
                'Current Physician',
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
                child: Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.only(
                          left: Sizing.sectionSymmPadding,
                          right: Sizing.sectionSymmPadding,
                          bottom: Sizing.sectionSymmPadding * 2,
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Dr. Jane Doe, M.D.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'University Physician',
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: popupActionWidget(),
                        ),
                      );
                    },
                  ),
                ),
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
                'Previous Physician/s',
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
                child: Column(
                  children: [
                    Container(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            margin: EdgeInsets.only(
                              bottom: Sizing.sectionSymmPadding / 2,
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    'Dr. John Doe, M.D.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'University Physician',
                                    // style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              // trailing: popupActionWidget(index),
                            ),
                          );
                        },
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.ellipsis,
                      color: Pallete.greyColor,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Sizing.borderRadius),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('See All Physicians'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> popupActionWidget() {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.pencil,
              color: Pallete.successColor,
            ),
            title: Text(
              'Change Physician',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Pallete.successColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPhysicianScreen(),
                ),
              );
            },
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
