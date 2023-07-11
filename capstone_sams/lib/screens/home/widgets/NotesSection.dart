import 'package:capstone_sams/theme/pallete.dart';
import 'package:capstone_sams/theme/sizing.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotesSection extends StatelessWidget {
  const NotesSection({
    super.key,
    required this.title,
    required this.press,
  });

  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: Sizing.sectionSymmPadding + 10,
            right: Sizing.sectionSymmPadding + 10,
            top: Sizing.sectionSymmPadding + 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Your Notes',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Pallete.textColor,
                    fontSize: Sizing.textSizeSection,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: press,
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Pallete.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.all(Sizing.sectionSymmPadding),
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
                child: Container(
                  // color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          'NAME\'s Goals',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('VALUE Targets'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
