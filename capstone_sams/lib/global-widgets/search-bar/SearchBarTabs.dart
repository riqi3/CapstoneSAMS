import 'package:capstone_sams/theme/sizing.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/pallete.dart';

import 'SearchPatientDelegate.dart';

//home app bar
class SearchBarTabs extends StatefulWidget {
  const SearchBarTabs({
    super.key,
  });

  @override
  State<SearchBarTabs> createState() => _SearchBarTabsState();
}

class _SearchBarTabsState extends State<SearchBarTabs>
    with SingleTickerProviderStateMixin {
  int pageIndex = 0;

  List<Widget> pageList = <Widget>[
    // StudentHome(),
    // UserProfile(),
  ];

  TabController? _controller;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final double minWidth = 250;
    final double maxWidth = 400;
    return Container(
      alignment: Alignment.center,
      child: AppBar(
        iconTheme: IconThemeData(
          color: Pallete.greyColor,
          size: 30,
        ),
        backgroundColor: Pallete.whiteColor,
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
              color: Pallete.greyColor,
              size: Sizing.iconAppBarSize,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: currentWidth < 300
              ? MainAxisAlignment.center
              : MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: SearchPatientDelegate(),
                );
                print('search patient');
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: currentWidth < 600 ? minWidth : maxWidth,
                  height: 40,
                  color: Pallete.lightGreyColor,
                  child: SearchBarDesign(),
                ),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          indicatorColor: Pallete.mainColor,
          controller: _controller,
          isScrollable: true,
          labelColor: Pallete.mainColor,
          tabs: [
            Tab(
              child: Text('EHR'),
            ),
            Tab(
              child: Text('LABS'),
            ),
          ],
        ),
      ),
    );
  }

  Row SearchBarDesign() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          size: 16,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          'Search A Patient...',
          style: TextStyle(
            fontSize: 18,
            color: Pallete.greyColor,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
