import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DiagnosisCardLoading extends StatelessWidget {
  const DiagnosisCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            color: Pallete.lightGreyColor2,
            child: ListTile(
              title: Row(
                children: [
                  Text('data'),
                ],
              ),
              subtitle: Row(
                children: [
                  Text('data'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
