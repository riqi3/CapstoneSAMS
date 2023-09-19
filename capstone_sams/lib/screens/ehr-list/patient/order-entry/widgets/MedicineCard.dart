import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/widgets/EditMedicineDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
 

import '../../../../../constants/Dimensions.dart';
import '../../../../../constants/theme/pallete.dart';

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
                  style: TextStyle(
                      color: Pallete.mainColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  '${medicine.name.toString()}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  '${medicine.instructions}',
                  style: TextStyle(fontSize: 12),
                  maxLines: null,
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'Quantity: ${medicine.quantity}',
                      style: TextStyle(
                        fontSize: 12,
                      ),
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
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= Dimensions.mobileWidth) {
                return _tabletView(medicineProvider);
              } else {
                return _mobileView(context, medicineProvider);
              }
            },
          ),
        ],
      ),
    );
  }

  Row _mobileView(BuildContext context, MedicineProvider medicineProvider) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => EditMedicineDialog(
                medicine: medicine,
                index: index,
              ),
            );
          },
          icon: FaIcon(
            FontAwesomeIcons.pen,
            color: Pallete.greenColor,
          ),
          label: Text('Edit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Pallete.greenColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            medicineProvider.removeMedicine(index);
          },
          icon: FaIcon(
            FontAwesomeIcons.trash,
            color: Pallete.redColor,
          ),
          label: Text('Remove'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Pallete.redColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
          ),
        ),
      ],
    );
  }

  PopupMenuButton<dynamic> _tabletView(MedicineProvider medicineProvider) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.pen,
              color: Pallete.greenColor,
            ),
            title: Text(
              'Edit',
              style: TextStyle(
                color: Pallete.greenColor,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => EditMedicineDialog(
                  medicine: medicine,
                  index: index,
                ),
              );
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.trash,
              color: Pallete.redColor,
            ),
            title: Text(
              'Delete',
              style: TextStyle(color: Pallete.redColor),
            ),
            onTap: () {
              medicineProvider.removeMedicine(index);
            },
          ),
        ),
      ],
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
