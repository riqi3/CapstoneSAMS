import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/pop-menu-buttons/FormCreationPopup.dart';
import 'package:capstone_sams/global-widgets/search-bar/widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';

import '../constants/theme/pallete.dart';

//home app bar
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.profile,
  });

  final String profile;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        iconTheme: IconThemeData(
          color: Pallete.textColor,
          size: 30,
        ),
        backgroundColor: Pallete.whiteColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: Sizing.sectionSymmPadding),
          child: CircleAvatar(
            radius: 20,
            backgroundImage:
                AssetImage('lib/sams_server/upload-photo${profile}'),
            backgroundColor: Colors.transparent,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: Sizing.sectionSymmPadding),
            Expanded(child: SearchBarWidget()),
            SizedBox(width: Sizing.sectionSymmPadding),
            FormCreationPopup(),
          ],
        ),
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
