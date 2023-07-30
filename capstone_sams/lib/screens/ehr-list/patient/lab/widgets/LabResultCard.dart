import 'package:capstone_sams/models/LabResultModel.dart';
import 'package:capstone_sams/providers/LabResultProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LabResultCard extends StatelessWidget {
  final LabResult labresult;
  final int index;

  LabResultCard({required this.labresult, required this.index});

  @override
  Widget build(BuildContext context) {
    final labresultProvider =
        Provider.of<LabResultProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${labresult.title.toString()}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          Row(
            children: [
              // ElevatedButton.icon(
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (context) => EditMedicineDialog(
              //         medicine: medicine,
              //         index: index,
              //       ),
              //     );
              //   },
              //   icon: Icon(Icons.edit),
              //   label: Text('Edit'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Pallete.greenColor,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     elevation: 5,
              //   ),
              // ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  labresultProvider.removeLabResult(index);
                },
                icon: Icon(Icons.delete),
                label: Text('Remove'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
