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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: <Widget>[
                CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(profile),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 20,),
                Text(
                  'Welcome ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Pallete.textColor,
                  ),
                ),
                Text(
                  'NAME',
                  style: TextStyle(
                    fontSize: 20,
                    color: Pallete.mainColor,
                  ),
                ),
              ],
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
        ),
      ],
    );
  }
}

//dynamic appbar
class AppBarSAMS extends StatelessWidget {
  const AppBarSAMS({
    super.key,
    required this.icon,
    required this.textColor,
    required this.backgroundColor,
  });

  final Color textColor, backgroundColor;
  final FaIcon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: icon,
        ),
        title: Text(
          'data',
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
