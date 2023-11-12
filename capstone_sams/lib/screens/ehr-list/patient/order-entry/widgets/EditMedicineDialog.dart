import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/Env.dart';
import '../../../../../constants/theme/pallete.dart';
import '../../../../../constants/theme/sizing.dart';

class EditMedicineDialog extends StatefulWidget {
  final Medicine medicine;
  final int index;

  EditMedicineDialog({required this.medicine, required this.index});

  @override
  _EditMedicineDialogState createState() => _EditMedicineDialogState();
}

class _EditMedicineDialogState extends State<EditMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  late Medicine _editedMedicine;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  late String token = context.read<AccountProvider>().token!;

  @override
  void initState() {
    super.initState();
    _editedMedicine = Medicine.copy(widget.medicine);
    _selectedStartDate = _editedMedicine.startDate;
    _selectedEndDate = _editedMedicine.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizing.borderRadius),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Edit Medication Order',
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
                          // showSelectedItems: true,
                        ),
                        asyncItems: (String filter) async {
                          var response = await Dio().get(
                            '${Env.prefix}/cpoe/medicines/',
                            queryParameters: {"filter": filter,},
                            options: Options(headers: {
                              "Content-Type": "application/json",
                              "Authorization": "Bearer $token",
                            }),
                          );
                          // var models = Medicine.fromJson(response.data);
                          var models = List<Medicine>.from(response.data
                              .map((json) => Medicine.fromJson(json)));
                          return models;
                        },
                        itemAsString: (Medicine medicine) =>
                            medicine.drugName.toString(),
                        onChanged: (Medicine? data) {
                          _editedMedicine.drugName = data?.drugName.toString();
                        },
                      ),
                      SizedBox(height: 10),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Instructions',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Pallete.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Pallete.palegrayColor,
                          ),
                          minLines: 4,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) =>
                              _editedMedicine.instructions = value,
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
                                    color: Pallete.primaryColor,
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
                                    color: Pallete.primaryColor,
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
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _editedMedicine.quantity =
                                  int.tryParse(value ?? ''),
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
                                _editedMedicine.startDate = _selectedStartDate;
                                _editedMedicine.endDate = _selectedEndDate;
                                Provider.of<MedicineProvider>(context,
                                        listen: false)
                                    .editMedicine(
                                        widget.index, _editedMedicine);
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
