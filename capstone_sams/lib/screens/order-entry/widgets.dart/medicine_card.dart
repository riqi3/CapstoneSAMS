import 'package:capstone_sams/models/medicine_model.dart';
import 'package:capstone_sams/providers/medicine_provider.dart';
import 'package:capstone_sams/screens/order-entry/widgets.dart/edit_medicine_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final int index;

  MedicineCard({required this.medicine, required this.index});

  @override
  Widget build(BuildContext context) {
    final medicineProvider =
        Provider.of<MedicineProvider>(context, listen: false);

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
                  '${_formatDate(medicine.startDate)} - ${_formatDate(medicine.endDate)}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Medicine: ${medicine.name}',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 5),
                Text(
                  'Instructions: ${medicine.instructions}',
                  style: TextStyle(fontSize: 12),
                  maxLines: null, // Allow unlimited lines for the instructions
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'Quantity: ${medicine.quantity}',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Refills: ${medicine.refills}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditMedicineDialog(
                      medicine: medicine,
                      index: index,
                    ),
                  );
                },
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  medicineProvider.removeMedicine(index);
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final month = monthNames[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }
}
