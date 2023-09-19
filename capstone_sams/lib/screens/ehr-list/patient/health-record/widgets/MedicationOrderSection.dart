 
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../constants/theme/pallete.dart';
import '../../../../../constants/theme/sizing.dart';

class MedicationOrderSection extends StatelessWidget {
  const MedicationOrderSection({
    super.key,
    required this.physicianName,
    // required this.dateOrdered,
    // required this.numberOfPrescriptions,
    required this.press,
  });

  final String physicianName;
  // final DateTime dateOrdered;
  // final int numberOfPrescriptions;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(
        //     left: Sizing.sectionSymmPadding + 10,
        //     right: Sizing.sectionSymmPadding + 10,
        //     top: Sizing.sectionSymmPadding + 10,
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Flexible(
        //         child: Text(
        //           'Electronic Health Records',
        //           overflow: TextOverflow.ellipsis,
        //           style: TextStyle(
        //             color: Pallete.textColor,
        //             fontSize: Sizing.header4,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //       ),
        //       TextButton(
        //         onPressed: press,
        //         child: Text(
        //           'See All',
        //           style: TextStyle(
        //             color: Pallete.mainColor,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        GestureDetector(
          onTap: press,
          child: Card(
            elevation: Sizing.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizing.roundedCorners),
            ),
            color: Pallete.whiteColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizing.sectionSymmPadding * 1.5,
                vertical: Sizing.sectionSymmPadding * 2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       right: Sizing.sectionSymmPadding),
                            //   child: FaIcon(
                            //     FontAwesomeIcons.solidClipboard,
                            //     color: Pallete.whiteColor,
                            //     size: Sizing.sectionIconSize,
                            //   ),
                            // ),
                            // Text(
                            //   dateOrdered.toIso8601String(),
                            //   overflow: TextOverflow.ellipsis,
                            //   style: TextStyle(
                            //     fontSize: Sizing.header4,
                            //     color: Pallete.whiteColor,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            Text(
                              physicianName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Sizing.header4,
                                color: Pallete.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Text(
                            //   'Rx: $numberOfPrescriptions',
                            //   overflow: TextOverflow.ellipsis,
                            //   style: TextStyle(
                            //     fontSize: Sizing.header4,
                            //     color: Pallete.whiteColor,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                          ],
                        ),
                        Spacer(),
                        FaIcon(
                          FontAwesomeIcons.chevronRight,
                          color: Pallete.mainColor,
                          size: Sizing.sectionIconSize,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
