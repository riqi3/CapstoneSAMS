import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardContentLoading extends StatelessWidget {
  const CardContentLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  color: Pallete.lightGreyColor2,
                  height: 25,
                  width: 120,
                ),
                SizedBox(width: Sizing.formSpacing),
                Container(
                  color: Pallete.lightGreyColor2,
                  height: 25,
                  width: 120,
                ),
              ],
            ),
            SizedBox(height: Sizing.formSpacing),
            Row(
              children: [
                Container(
                  color: Pallete.lightGreyColor2,
                  height: 20,
                  width: 50,
                ),
                SizedBox(width: Sizing.formSpacing),
                Container(
                  color: Pallete.lightGreyColor2,
                  height: 20,
                  width: 150,
                ),
              ],
            ),
            SizedBox(height: Sizing.formSpacing),
            Row(
              children: [
                Container(
                  color: Pallete.lightGreyColor2,
                  height: 20,
                  width: 50,
                ),
                SizedBox(width: Sizing.formSpacing),
                Container(
                  color: Pallete.lightGreyColor2,
                  height: 20,
                  width: 150,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
