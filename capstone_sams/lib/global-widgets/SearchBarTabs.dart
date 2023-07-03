import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/pallete.dart';
import '../../../theme/sizing.dart';

//home app bar
class SearchBarTabs extends StatelessWidget {
  const SearchBarTabs({
    super.key,
     
  });

   
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        iconTheme: IconThemeData(color: Pallete.textColor, size: 30),
        backgroundColor: Pallete.mainColor,
        elevation: 8,
        shadowColor: Pallete.greyColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: FaIcon(FontAwesomeIcons.arrowLeft, color: Pallete.whiteColor,),
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
