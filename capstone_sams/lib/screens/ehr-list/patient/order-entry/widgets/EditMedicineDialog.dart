import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/global-widgets/text-fields/Textfields.dart';
import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/models/PatientModel.dart'; 
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
  final Patient patient;
  final int index;

  EditMedicineDialog(
      {required this.medicine, required this.patient, required this.index});

  @override
  _EditMedicineDialogState createState() => _EditMedicineDialogState();
}

class _EditMedicineDialogState extends State<EditMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  late Medicine _editedMedicine;

  late List<dynamic>? medicines;

  int? maxLines = 4;
  late String token = context.read<AccountProvider>().token!;

  late bool _autoValidate = false;
  @override
  void initState() {
    super.initState();
    _editedMedicine = Medicine.copy(widget.medicine);
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
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
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
                        ),
                        selectedItem: widget.medicine,
                        asyncItems: (String filter) async {
                          var response = await Dio().get(
                            '${Env.prefix}/cpoe/medicines/',
                            queryParameters: {
                              "filter": filter,
                            },
                            options: Options(headers: {
                              "Content-Type": "application/json",
                              "Authorization": "Bearer $token",
                            }),
                          );
                          var models = List<Medicine>.from(response.data
                              .map((json) => Medicine.fromJson(json)));
                          return models;
                        },
                        itemAsString: (Medicine medicine) =>
                            medicine.drugName.toString(),
                        onSaved: (Medicine? data) {
                          if (data != null) {
                            setState(() {
                              _editedMedicine.drugId = data.drugId;
                              _editedMedicine.drugCode = data.drugCode;
                              _editedMedicine.drugName = data.drugName;
                            });
                          } else { 
                            setState(() {
                              _editedMedicine.drugId = widget.medicine.drugId;
                              _editedMedicine.drugCode =
                                  widget.medicine.drugCode;
                              _editedMedicine.drugName =
                                  widget.medicine.drugName;
                            });
                          }
                        },
                        // {
                        //   setState(() {
                        //     widget.medicine.drugId =
                        //         _editedMedicine.drugId = data?.drugId;
                        //     widget.medicine.drugCode =
                        //         _editedMedicine.drugCode = data?.drugCode;
                        //     widget.medicine.drugName =
                        //         _editedMedicine.drugName = data?.drugName;

                        //     print(
                        //         'Selected Medicine: ${data?.drugName}, ${data?.drugCode}');
                        //     print(
                        //         'Edited Medicine: ${_editedMedicine.drugName}, ${_editedMedicine.drugCode}');
                        //   });
                        // },
                      ),
                      SizedBox(height: 10),
                      Flexible(
                        child: FormTextField(
                          initialvalue: widget.medicine.instructions,
                          onchanged: (value) => widget.medicine.instructions =
                              _editedMedicine.instructions = value,
                          labeltext: '',
                          validator: Strings.requiredField,
                          maxlines: maxLines,
                          type: TextInputType.streetAddress,
                        ),
                      ),
                      SizedBox(height: 10),
                      Flexible(
                        child: FormTextField(
                          initialvalue: widget.medicine.quantity.toString(),
                          // onchanged: (value) =>
                          //     _editedMedicine.quantity = int.parse(value),
                          onchanged: (value) {
                            try {
                              _editedMedicine.quantity = int.parse(value);
                            } catch (e) {
                              // Handle parsing error, e.g., show a message to the user
                              print("Error parsing quantity: $e");
                            }
                          },
                          labeltext: '',
                          validator: Strings.requiredField,
                          type: TextInputType.number,
                        ),
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
                                Provider.of<MedicineProvider>(context,
                                        listen: false)
                                    .editMedicine(
                                        widget.index, _editedMedicine);

                                _formKey.currentState!.save();

                                print(
                                    'TEST YO ${widget.index} ${widget.medicine.drugCode}');

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
