import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/pallete.dart';
import '../../../theme/sizing.dart';

//home app bar
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.profile,
    required this.textColor,
    required this.backgroundColor,
  });

  final Color textColor, backgroundColor;
  final String profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              print('dashboard');
            },
            icon: FaIcon(
              FontAwesomeIcons.alignJustify,
              color: Pallete.textColor,
            ),
          ),
        ],
        title: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print('profile');
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profile),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              'Welcome ',
              style: TextStyle(
                fontSize: Sizing.fsAppBar,
                color: Pallete.textColor,
              ),
            ),
            Text(
              'NAME',
              style: TextStyle(
                fontSize: Sizing.fsAppBar,
                color: Pallete.mainColor,
              ),
            ),
            Text(
              '!',
              style: TextStyle(
                fontSize: Sizing.fsAppBar,
                color: Pallete.textColor,
              ),
            ),
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
