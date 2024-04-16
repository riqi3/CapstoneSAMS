// add_medicine_dialog.dart

import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/text-fields/Textfields.dart';
import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/Env.dart';
import '../../../../../constants/theme/pallete.dart';

// ignore: must_be_immutable
class AddMedicineDialog extends StatefulWidget {
  AddMedicineDialog({
    Key? key,
  }) : super(key: key);
  @override
  _AddMedicineDialogState createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  final _medicine = Medicine();
  late String token = context.read<AccountProvider>().token!;

  late Future<List<Medicine>> medicines;
  late bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
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
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DropdownSearch<Medicine>(
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              InputDecoration(labelText: "Medication*"),
                        ),
                        // autoValidateMode: AutovalidateMode.always,
                        validator: (value) =>
                            value == null ? Strings.requiredField : null,
                        clearButtonProps: ClearButtonProps(isVisible: true),
                        popupProps: PopupProps.modalBottomSheet(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps()
                        ),
                        asyncItems: (String filter) async {
                          var response = await Dio().get(
                            '${Env.prefix}/cpoe/medicines/',
                            queryParameters: {"filter": filter},
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
                        onChanged: (Medicine? data) {
                          _medicine.drugId = data?.drugId.toString();
                          _medicine.drugName = data?.drugName.toString();
                          _medicine.drugCode = data?.drugCode.toString();
                        },
                      ),
                      SizedBox(height: 10),
                      Flexible(
                        child: FormTextField(
                          onchanged: (value) => _medicine.instructions = value,
                          labeltext: 'Sig*',
                          validator: Strings.requiredField,
                          type: TextInputType.streetAddress,
                          maxlines: 4,
                        ),
                        // TextFormField(
                        //   decoration: InputDecoration(
                        //     labelText: 'Instructions',
                        //     border: OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: Pallete.primaryColor,
                        //       ),
                        //     ),
                        //     filled: true,
                        //     fillColor: Pallete.palegrayColor,
                        //   ),
                        //   minLines: 4,
                        //   maxLines: null,
                        //   keyboardType: TextInputType.multiline,
                        //   onSaved: (value) => _medicine.instructions = value,
                        // ),
                      ),
                      SizedBox(height: 10),
                      Flexible(
                        child: FormTextField(
                          onchanged: (value) =>
                              _medicine.quantity = int.tryParse(value ?? ''),
                          labeltext: 'Quantity*',
                          // validator: Strings.requiredField,
                          type: TextInputType.number,
                        ),
                      ),
                      // TextFormField(
                      //   decoration: InputDecoration(
                      //     labelText: 'Quantity',
                      //     border: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: Pallete.primaryColor,
                      //       ),
                      //     ),
                      //     filled: true,
                      //     fillColor: Pallete.palegrayColor,
                      //   ),
                      //   keyboardType: TextInputType.number,
                      //   onSaved: (value) =>
                      //       _medicine.quantity = int.tryParse(value ?? ''),
                      // ),
                      SizedBox(height: Sizing.spacing),
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

                                Provider.of<MedicineProvider>(context,
                                        listen: false)
                                    .addMedicine(_medicine);
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  _autoValidate =
                                      true;  
                                });
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
