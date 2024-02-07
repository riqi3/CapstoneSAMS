//dynamic appbar
import 'package:capstone_sams/global-widgets/forms/PatientRegistrationForm.dart';
import 'package:capstone_sams/global-widgets/pop-menu-buttons/pop-menu-item/PopMenuItemTemplate.dart';
import 'package:capstone_sams/global-widgets/search-bar/widgets/SearchBarWidget.dart';
import 'package:capstone_sams/screens/medical_notes/MedicalNotesScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../constants/theme/pallete.dart';
import '../constants/theme/sizing.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    super.key,
    required this.iconColorLeading,
    required this.iconColorTrailing,
    required this.backgroundColor,
    this.bottom,
  });

  final Color backgroundColor, iconColorLeading, iconColorTrailing;
  final PreferredSize? bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        iconTheme: IconThemeData(
          color: iconColorTrailing,
          size: 30,
        ),
        backgroundColor: backgroundColor,
        // elevation: 8,
        // shadowColor: Pallete.greyColor,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: iconColorLeading,
              size: Sizing.iconAppBarSize,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: SearchBarWidget()),
            SizedBox(width: Sizing.sectionSymmPadding),
            PopupMenuButton(
              icon: FaIcon(
                FontAwesomeIcons.circlePlus,
                size: Sizing.iconAppBarSize,
              ),
              itemBuilder: ((context) => [
                    PopupMenuItem(
                      child: PopMenuItemTemplate(
                        icon: FontAwesomeIcons.personCirclePlus,
                        color: Pallete.infoColor,
                        size: Sizing.sectionSymmPadding,
                        title: 'Register Patient',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientRegistrationForm(),
                            ),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: PopMenuItemTemplate(
                        icon: FontAwesomeIcons.pen,
                        color: Pallete.infoColor,
                        size: Sizing.sectionSymmPadding,
                        title: 'Notes',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicalNotes(),
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
            ),
            // GestureDetector(
            //   onTap: () {
            //     print('object');
            //   },
            //   child: FaIcon(
            //     FontAwesomeIcons.circlePlus,
            //     size: Sizing.iconAppBarSize,
            //   ),
            // ),
          ],
        ),
        bottom: bottom,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Pallete.greyColor.withOpacity(.5),
            offset: Offset(0, 7.0),
            blurRadius: 4.0,
          ),
        ],
      ),
    );
  }
}
