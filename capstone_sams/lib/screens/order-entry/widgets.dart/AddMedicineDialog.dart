// add_medicine_dialog.dart
import 'package:capstone_sams/models/medicine_model.dart';
import 'package:capstone_sams/providers/medicine_provider.dart';
import 'package:capstone_sams/theme/pallete.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/Env.dart';

class AddMedicineDialog extends StatefulWidget {
  @override
  _AddMedicineDialogState createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  final _medicine = Medicine();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  late Future<List<Medicine>> medicines;

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();

    _printLatestValue() {
      print("text field: ${textController.text}");
    }

    @override
    void initState() {
      super.initState();
      // Start listening to changes.
      textController.addListener(_printLatestValue);
    }

    @override
    void dispose() {
      // Clean up the controller when the widget is removed from the
      // widget tree.
      textController.dispose();
      super.dispose();
    }

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
                          'Medication Order',
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
                      DropdownSearch<Medicine>(
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              InputDecoration(labelText: "Medication"),
                        ),
                        clearButtonProps: ClearButtonProps(isVisible: true),
                        popupProps: PopupProps.modalBottomSheet(
                          showSearchBox: true,
                          showSelectedItems: true,
                        ),
                        asyncItems: (String filter) async {
                          var response = await Dio().get(
                            '${Env.prefix}/cpoe/medicines/',
                            queryParameters: {"filter": filter},
                          );
                          // var models = Medicine.fromJson(response.data);
                          var models = List<Medicine>.from(response.data
                              .map((json) => Medicine.fromJson(json)));
                          return models;
                        },
                        itemAsString: (Medicine medicine) =>
                            medicine.name.toString(),
                        onChanged: (Medicine? data) {
                          _medicine.name = data?.name.toString();
                          print('MEDICATION: ${data?.name.toString()}');
                        },
                        onSaved: (value) {
                          _medicine.name;
                        },
                      ),
                      // DropdownSearch<int>(
                      //   items: List.generate(3, (i) => i),
                      //   dropdownDecoratorProps: DropDownDecoratorProps(
                      //     dropdownSearchDecoration:
                      //         InputDecoration(labelText: "Medication"),
                      //   ),
                      //   clearButtonProps: ClearButtonProps(isVisible: true),
                      //   popupProps: PopupProps.modalBottomSheet(
                      //     showSearchBox: true,
                      //     showSelectedItems: true,
                      //   ),
                      //   asyncItems: (String filter) async {
                      //     var response = await Dio().get(
                      //       '${Env.prefix}/cpoe/medicines/',
                      //       queryParameters: {"filter": filter},
                      //     );
                      //     // var models = Medicine.fromJson(response.data);
                      //     var models = List<Medicine>.from(response.data
                      //         .map((json) => Medicine.fromJson(json)));
                      //     return models;
                      //   },
                      //   itemAsString: (Medicine medicine) =>
                      //       medicine.name.toString(),
                      //   onChanged: (Medicine? data) {
                      //     _medicine.name = data?.name.toString();
                      //     print('MEDICATION: ${data?.name.toString()}');
                      //   },
                      //   onSaved: (value) {
                      //     _medicine.name;
                      //   },
                      // ),
                      SizedBox(height: 10),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Instructions',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Pallete.paleblueColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Pallete.palegrayColor,
                          ),
                          minLines: 4,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => _medicine.instructions = value,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Start Date',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.paleblueColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    setState(() {
                                      _selectedStartDate = selectedDate;
                                    });
                                  }
                                });
                              },
                              controller: TextEditingController(
                                text: _selectedStartDate != null
                                    ? _selectedStartDate!
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0]
                                    : '',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.paleblueColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate:
                                      _selectedStartDate ?? DateTime.now(),
                                  firstDate:
                                      _selectedStartDate ?? DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    setState(() {
                                      _selectedEndDate = selectedDate;
                                    });
                                  }
                                });
                              },
                              controller: TextEditingController(
                                text: _selectedEndDate != null
                                    ? _selectedEndDate!
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0]
                                    : '',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.paleblueColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _medicine.quantity =
                                  int.tryParse(value ?? ''),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Refills',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.paleblueColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) =>
                                  _medicine.refills = int.tryParse(value ?? ''),
                            ),
                          ),
                        ],
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
                                _medicine.startDate = _selectedStartDate;
                                _medicine.endDate = _selectedEndDate;
                                Provider.of<MedicineProvider>(context,
                                        listen: false)
                                    .addMedicine(_medicine);
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
