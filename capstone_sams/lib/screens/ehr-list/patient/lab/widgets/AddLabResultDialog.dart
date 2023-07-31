import 'package:capstone_sams/models/LabResultModel.dart';
import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/providers/LabResultProvider.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';
import 'package:capstone_sams/theme/Pallete.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/Env.dart';

class AddLabResultDialog extends StatefulWidget {
  @override
  _AddLabResultDialogState createState() => _AddLabResultDialogState();
}

class _AddLabResultDialogState extends State<AddLabResultDialog> {
  final _formKey = GlobalKey<FormState>();
  final _labResult = LabResult();

  late Future<List<Medicine>> medicines;

  @override
  Widget build(BuildContext context) {
    final labresultProvider =
        Provider.of<LabResultProvider>(context, listen: false);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Lab Result',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DropdownSearch<LabResult>(
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              InputDecoration(labelText: "Select PDF To Scan"),
                        ),
                        clearButtonProps: ClearButtonProps(isVisible: true),
                        popupProps: PopupProps.modalBottomSheet(
                          showSearchBox: true,
                          // showSelectedItems: true,
                        ),
                        asyncItems: (String filter) async {
                          var response = await Dio().get(
                            '${Env.prefix}/laboratory/labresult/',
                            queryParameters: {"filter": filter},
                          );
                          // var models = Medicine.fromJson(response.data);
                          var models = List<LabResult>.from(response.data
                              .map((json) => LabResult.fromJson(json)));
                          return models;
                        },
                        itemAsString: (LabResult labresult) {
                          final s = labresult.pdf.toString();

                          print('HELLO EVERYNYAN ${s}');
                          return s;
                        },
                        onChanged: (LabResult? data) {
                          _labResult.title = data?.title.toString();
                          print('LAB RESULT: ${data?.title.toString()}');
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.greyColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            child: Text('Submit'),
                            onPressed: () {
                               
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                labresultProvider.addLabResult(_labResult);
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
