import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardTemplate extends StatelessWidget {
  Column column;
  CardTemplate({super.key, required this.column});

  @override
  Widget build(BuildContext context) {
    return Container( 
      margin: EdgeInsets.symmetric(vertical: Sizing.sectionSymmPadding),
      child: Material(
        elevation: Sizing.cardElevation,
        borderRadius: BorderRadius.all(
          Radius.circular(Sizing.borderRadius),
        ),
        child: column,
      ),
    );
  }
}
