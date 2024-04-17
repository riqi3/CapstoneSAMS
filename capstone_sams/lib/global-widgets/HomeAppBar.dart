import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/pop-menu-buttons/FormCreationPopup.dart';
import 'package:capstone_sams/global-widgets/search-bar/widgets/SearchBarWidget.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:flutter/material.dart';

import '../constants/theme/pallete.dart';

//home app bar
// ignore: must_be_immutable
class HomeAppBar extends StatefulWidget {
  AccountProvider user;
  HomeAppBar({
    super.key,
    required this.user,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  String profilePic() {
    if (widget.user.role == 'physician') {
      return 'assets/images/phy_profilepic.png';
    }
    if (widget.user.role == 'nurse') {
      return 'assets/images/nur_profilepic.png';
    }
    if (widget.user.role == 'working student') {
      return 'assets/images/ws_profilepic.png';
    }

    return 'assets/images/nur_profilepic.png';
  }

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
            backgroundImage: AssetImage(profilePic()),
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
