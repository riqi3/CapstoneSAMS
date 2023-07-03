import 'package:flutter/material.dart';

import '../../../theme/pallete.dart';
import '../../../theme/sizing.dart';

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
        iconTheme: IconThemeData(color: Pallete.textColor, size: 30),
        backgroundColor: Pallete.whiteColor,
        elevation: 8,
        shadowColor: Pallete.greyColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(profile),
            backgroundColor: Colors.transparent,
          ),
        ),
        title: Row(
          children: <Widget>[
            SizedBox(
              width: 5,
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
    );
  }
}
