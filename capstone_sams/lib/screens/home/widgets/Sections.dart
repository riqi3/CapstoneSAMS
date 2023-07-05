import 'package:capstone_sams/screens/home/widgets/HomeAppBar.dart';
import 'package:capstone_sams/theme/pallete.dart';
import 'package:capstone_sams/theme/sizing.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EHRSection extends StatelessWidget {
  const EHRSection({
    super.key,
    required this.title,
    required this.press,
  });

  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {


    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      onTap: press,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                
                // width: currentWidth < 600 ?   minWidth : maxWidth,
                color: Pallete.mainColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizing.sectionSymmPadding,
                  ),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidClipboard,
                        color: Pallete.whiteColor,
                        size: Sizing.sectionIconSize,
                      ),
                      Text(
                        'Patient Health Records: ',
                        style: TextStyle(
                          fontSize: 30,
                          color: Pallete.whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Pallete.whiteColor,
                        size: Sizing.sectionIconSize,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
