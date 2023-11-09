//dynamic appbar
import 'package:capstone_sams/global-widgets/search-bar/widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/theme/pallete.dart';
import '../constants/theme/sizing.dart';

class TitleAppBar extends StatelessWidget {
  const TitleAppBar({
    super.key,
    required this.text,
    required this.iconColorLeading,
    required this.iconColorTrailing,
    required this.backgroundColor,
    this.bottom,
  });

  final Color backgroundColor, iconColorLeading, iconColorTrailing;
  final PreferredSize? bottom;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        iconTheme: IconThemeData(
          color: iconColorTrailing,
          size: 30,
        ),
        backgroundColor: backgroundColor,
        elevation: 8,
        shadowColor: Pallete.greyColor,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: iconColorLeading,
              size: Sizing.iconAppBarSize,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            SearchBarWidget(),
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
