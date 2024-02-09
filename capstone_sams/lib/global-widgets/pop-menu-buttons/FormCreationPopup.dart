import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/forms/PatientRegistrationForm.dart';
import 'package:capstone_sams/global-widgets/pop-menu-buttons/pop-menu-item/PopMenuItemTemplate.dart';
import 'package:capstone_sams/screens/medical_notes/MedicalNotesScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class FormCreationPopup extends StatelessWidget {
  const FormCreationPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
    );
  }
}
