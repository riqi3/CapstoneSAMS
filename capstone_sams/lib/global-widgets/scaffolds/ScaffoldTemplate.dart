import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScaffoldTemplate extends StatelessWidget {
  Column column;
  ScrollController? scrollcontroller;
  FloatingActionButton? fab;
  FloatingActionButtonLocation? fablocation;
  ScaffoldTemplate({
    super.key,
    required this.column,
    this.fab,
    this.scrollcontroller,
    this.fablocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollcontroller,
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: column,
      ),
      floatingActionButtonLocation: fablocation,
      floatingActionButton: fab,
    );
  }
}
