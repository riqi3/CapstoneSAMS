import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/SearchAppBar.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  final Prescription prescription;
  const CounterScreen({
    Key? key,
    required this.prescription,
  }) : super(key: key);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  // final array = prescription.medicines[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizing.headerHeight),
        child: SearchAppBar(
          backgroundColor: Pallete.mainColor,
          iconColorLeading: Pallete.whiteColor,
          iconColorTrailing: Pallete.whiteColor,
        ),
      ),
      endDrawer: ValueDashboard(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Container(
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
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizing.sectionSymmPadding),
                  width: MediaQuery.of(context).size.width,
                  height: Sizing.cardContainerHeight,
                  child: Text(
                    'Medication Information',
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
                    child: Text('data'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
