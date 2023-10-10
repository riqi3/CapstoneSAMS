import 'package:capstone_sams/models/LabResultModel.dart';
import 'package:flutter/material.dart';

class SubCategory extends StatelessWidget {
  // final Labresult labresult;
  final String name;
  SubCategory({
    Key? key,
    // required this.labresult,
    required this.name,
  }) : super(key: key);

  @override
  // Widget build(BuildContext context) {
  //   if (labresult.jsonTables!.isEmpty) {
  //     return Builder(
  //       builder: (context) {
  //         return ListTile(
  //           title: Text(labresult.comment),
  //         );
  //       },
  //     );
  //   }
  //   return ExpansionTile(
  //     title: Text(labresult.title),
  //     children: labresult.jsonTables!.map((e) {
  //       return Text(labresult.comment.toString());
  //     }).toList(),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name),),
      body: Center(child: Text(
      'This is $name category screen'
      ),)
    );
  }
}
