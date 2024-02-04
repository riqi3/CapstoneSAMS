import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PatientCardLoadingPhone extends StatelessWidget {
  const PatientCardLoadingPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Card(
            color: Pallete.lightGreyColor2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizing.borderRadius),
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 5),
      ),
    );
  }
}

class PatientCardLoadingTablet extends StatelessWidget {
  const PatientCardLoadingTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Card(
            color: Pallete.lightGreyColor2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizing.borderRadius),
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 16 / 10,
      ),
    );
  }
}
