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
      margin: EdgeInsets.only(bottom: Sizing.sectionSymmPadding),
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
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Sizing.borderRadius),
                  bottomRight: Radius.circular(Sizing.borderRadius)),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
