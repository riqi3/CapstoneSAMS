
//dynamic appbar
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/pallete.dart';

class AppBarSAMS extends StatelessWidget {
  const AppBarSAMS({
    super.key,
    required this.text,
    required this.icon,
    required this.textColor,
    required this.backgroundColor,
  });

  final Color textColor, backgroundColor;
  final FaIcon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                print('dashboard');
              },
              icon: FaIcon(
                FontAwesomeIcons.alignJustify,
                color: Pallete.textColor,
              ))
        ],
        leading: IconButton(
          onPressed: () {},
          icon: icon,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
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
