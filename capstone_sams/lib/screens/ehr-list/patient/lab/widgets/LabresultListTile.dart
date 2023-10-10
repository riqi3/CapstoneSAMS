// import 'package:capstone_sams/models/LabResultModel.dart';
// import 'package:flutter/material.dart';

// class LabresultListTile extends StatefulWidget {
//   const LabresultListTile({
//     required this.labresult,
//     super.key,
//   });
//   final Labresult labresult;

//   @override
//   State<LabresultListTile> createState() => _LabresultListTileState();
// }

// class _LabresultListTileState extends State<LabresultListTile> {
   

//   // @override
//   // void initState() {
//   //   dataList.forEach((element) {
//   //     data.add(LabResult.fromJson(element));
//   //   });
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: labresult.,
//         itemBuilder: (BuildContext context, int index) =>
//             _buildList(data[index]),
//       ),
//     );
//   }
// }

// Widget _buildList(Menu list) {
//   if (list.subMenu.isEmpty)
//     return Builder(builder: (context) {
//       return ListTile(
//           onTap: () => Navigator.push(context,
//               MaterialPageRoute(builder: (context) => SubCategory(list.name))),
//           leading: SizedBox(),
//           title: Text(list.name));
//     });
//   return ExpansionTile(
//     leading: Icon(list.icon),
//     title: Text(
//       list.name,
//       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//     ),
//     children: list.subMenu.map(_buildList).toList(),
//   );
// }
