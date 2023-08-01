import 'package:capstone_sams/models/LabResultModel.dart';
import 'package:flutter/material.dart';
import '../../../../../theme/Pallete.dart';
import '../../../../../theme/Sizing.dart';

class LabResultCard extends StatelessWidget {
  final LabResult labresult;
  final int index;

  LabResultCard({required this.labresult, required this.index});

  @override
  Widget build(BuildContext context) {
    final matrix = labresult.jsonData['data'];
    final firstColumn = matrix.map((row) => row[0]['text']).toList();
    final second2lastColumn = List.generate(
      matrix[0].length - 1,
      (int columnIndex) =>
          matrix.map((row) => row[columnIndex + 1]["text"]).toList(),
    );

    print('aaaa${second2lastColumn}');
    print(firstColumn);
    return Container(
      margin: EdgeInsets.symmetric(vertical: Sizing.sectionSymmPadding),
      child: Material(
        elevation: Sizing.cardElevation,
        borderRadius: BorderRadius.all(
          Radius.circular(Sizing.borderRadius),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Pallete.mainColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Sizing.borderRadius),
                    topLeft: Radius.circular(Sizing.borderRadius)),
              ),
              alignment: Alignment.centerLeft,
              padding:
                  EdgeInsets.symmetric(horizontal: Sizing.sectionSymmPadding),
              width: MediaQuery.of(context).size.width,
              height: Sizing.cardContainerHeight,
              child: Text(
                'CBC Result',
                style: TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: Sizing.header3,
                    fontWeight: FontWeight.w600),
              ),
            ),

            Expanded(
              child: Material(
                // elevation: Sizing.cardElevation,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Sizing.borderRadius),
                    bottomRight: Radius.circular(Sizing.borderRadius)),
                child: Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Pallete.whiteColor,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(Sizing.borderRadius),
                          bottomLeft: Radius.circular(Sizing.borderRadius)),
                    ),
                    padding: const EdgeInsets.only(
                      top: Sizing.sectionSymmPadding / 2,
                      bottom: Sizing.sectionSymmPadding,
                      left: Sizing.sectionSymmPadding,
                      right: Sizing.sectionSymmPadding,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: matrix[0].map<DataColumn>((item) {
                            return DataColumn(label: Text('test'));
                          }).toList(),
                          rows: matrix.map<DataRow>((row) {
                            return DataRow(
                              cells: row.map<DataCell>((cell) {
                                return DataCell(Text(cell['text'] ?? ''));
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    //
                    //
                    // Table(
                    //   border: TableBorder.all(
                    //       color: Colors.black, style: BorderStyle.solid, width: 2),
                    //   children: [
                    //     TableRow(
                    //       children: [
                    //         Column(
                    //           children: [
                    //             Text(
                    //               labresult.jsonData['data'][0][0]['text'],
                    //               style: TextStyle(
                    //                   fontSize: 13, fontWeight: FontWeight.bold),
                    //             ),
                    //             Text(
                    //               labresult.jsonData['data'][1][1]['text'],
                    //               style: TextStyle(
                    //                   fontSize: 13, fontWeight: FontWeight.bold),
                    //             ),
                    //             Text(
                    //               labresult.jsonData['data'][2][2]['text'],
                    //               style: TextStyle(
                    //                   fontSize: 13, fontWeight: FontWeight.bold),
                    //             ),
                    //             Text(
                    //               labresult.jsonData['data'][3][0]['text'],
                    //               style: TextStyle(
                    //                   fontSize: 13, fontWeight: FontWeight.bold),
                    //             ),
                    //           ],
                    //         ),
                    //         Column(
                    //           children: [
                    //             Text(
                    //               labresult.jsonData['data'][1][2]['text'],
                    //               style: TextStyle(
                    //                   fontSize: 13, fontWeight: FontWeight.bold),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),
            ),

            // Container(
            //   alignment: Alignment.centerLeft,
            //   padding: EdgeInsets.symmetric(horizontal: 40),
            //   width: MediaQuery.of(context).size.width,
            //   height: 100,
            //   color: Pallete.whiteColor,
            // ),
          ],
        ),
      ),
    );

    // Container(
    //   margin: EdgeInsets.all(10),
    //   padding: EdgeInsets.all(10),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(10),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.grey.withOpacity(0.5),
    //         spreadRadius: 2,
    //         blurRadius: 5,
    //         offset: Offset(0, 3),
    //       ),
    //     ],
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               labresult.jsonData['data'][0][0]['text'],
    //               style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    //             ),
    //             // Flexible(
    //             //   child: Text(
    //             //     '${labresult.jsonData.toString()}',
    //             //     overflow: TextOverflow.clip,
    //             //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    //             //   ),
    //             // ),
    //             SizedBox(height: 5),
    //           ],
    //         ),
    //       ),
    //       Row(
    //         children: [
    //           // ElevatedButton.icon(
    //           //   onPressed: () {
    //           //     showDialog(
    //           //       context: context,
    //           //       builder: (context) => EditMedicineDialog(
    //           //         medicine: medicine,
    //           //         index: index,
    //           //       ),
    //           //     );
    //           //   },
    //           //   icon: Icon(Icons.edit),
    //           //   label: Text('Edit'),
    //           //   style: ElevatedButton.styleFrom(
    //           //     backgroundColor: Pallete.greenColor,
    //           //     shape: RoundedRectangleBorder(
    //           //       borderRadius: BorderRadius.circular(10.0),
    //           //     ),
    //           //     elevation: 5,
    //           //   ),
    //           // ),
    //           SizedBox(width: 10),
    //           ElevatedButton.icon(
    //             onPressed: () {
    //               labresultProvider.removeLabResult(index);
    //             },
    //             icon: Icon(Icons.delete),
    //             label: Text('Remove'),
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor: Colors.red,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10.0),
    //               ),
    //               elevation: 5,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
