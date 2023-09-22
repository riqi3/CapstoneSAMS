import 'package:capstone_sams/models/LabResultModel.dart';
import 'package:flutter/material.dart';

class SubCategory extends StatelessWidget {
  final Labresult labresult;
  SubCategory({
    Key? key,
    required this.labresult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (labresult.jsonTables!.isEmpty) {
      return Builder(
        builder: (context) {
          return ListTile(
            title: Text(labresult.comment),
          );
        },
      );
    }
    return ExpansionTile(
      title: Text(labresult.title),
      children: labresult.jsonTables!.map((e) {
        return Text(e.toString());
      }).toList(),
    );
  }
}
