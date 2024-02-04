import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContactInfoLoading extends StatelessWidget {
  const ContactInfoLoading({super.key});

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
                  height: 30,
                  width: 120,
                ),
                SizedBox(width: Sizing.formSpacing),
                Container(
                  color: Pallete.lightGreyColor2,
                  height: 30,
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
                  width: 100,
                ),
              ],
            ),
            SizedBox(height: Sizing.formSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Pallete.lightGreyColor2,
                  height: 20,
                  width: 80,
                ),
                SizedBox(width: Sizing.formSpacing),
                Container(
                  color: Pallete.lightGreyColor2,
                  height: 50,
                  width: 200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
