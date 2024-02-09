//dynamic appbar
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/theme/pallete.dart';
import '../constants/theme/sizing.dart';

// ignore: must_be_immutable
class TitleAppBar extends StatelessWidget {
  final Color backgroundColor, iconColorLeading, iconColorTrailing;
  final PreferredSize? bottom;
  final String text;
  late final dynamic onpressed;
  TitleAppBar({
    super.key,
    required this.text,
    required this.iconColorLeading,
    required this.iconColorTrailing,
    required this.backgroundColor,
    required this.onpressed,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        iconTheme: IconThemeData(
          color: iconColorTrailing,
          size: 30,
        ),
        backgroundColor: backgroundColor,
        shadowColor: Pallete.greyColor,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          child: IconButton(
            onPressed: onpressed,

            // () {
            //   Navigator.pop(context);
            //   // Navigator.pushReplacement(
            //   //   context,
            //   //   MaterialPageRoute(
            //   //     builder: (context) => HomeScreen(),
            //   //   ),
            //   // );
            // },
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: iconColorLeading,
              size: Sizing.iconAppBarSize,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // SizedBox(
            //   width: 5,
            // ),
            // SearchBarWidget(),
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
