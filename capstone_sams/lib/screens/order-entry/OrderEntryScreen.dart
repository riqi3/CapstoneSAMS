import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/global-widgets/date-picker/DatePicker.dart';
import 'package:capstone_sams/global-widgets/text-fields/Textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../declare/ValueDeclaration.dart';
import '../../models/medicine_model.dart';
import '../../providers/medicine_provider.dart';
import '../../theme/pallete.dart';
import '../../theme/sizing.dart';

class OrderEntryScreen extends StatefulWidget {
  const OrderEntryScreen({super.key});

  @override
  State<OrderEntryScreen> createState() => _OrderEntryScreenState();
}

class _OrderEntryScreenState extends State<OrderEntryScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _medicine = Medicine();
    DateTime? _selectedStartDate;
    DateTime? _selectedEndDate;

    return Scaffold(
      endDrawer: ValueDashboard(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizing.headerHeight),
        // child: SearchBarTabs(),
        child: TitleAppBar(
          text: 'Medication Order',
          iconColorLeading: Pallete.whiteColor,
          iconColorTrailing: Pallete.whiteColor,
          backgroundColor: Pallete.mainColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding,
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
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Medication',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Pallete.paleblueColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Pallete.palegrayColor,
                          ),
                          onSaved: (value) => _medicine.name = value,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a medicine';
                            }
                            return null;
                          },
                        ),
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
                                onSaved: (value) => _medicine.refills =
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

        // Form(
        //   key: _formKey,
        //   child: Column(
        //     children: [
        //       TextAreaField(
        //         validator: 'Please provide instructions for the prescription.',
        //         hintText: 'Instructions...',
        //         onSaved: _medicine.instructions,
        //       ),
        //       Row(
        //         children: <Widget>[
        //           Expanded(
        //             child: TextFormField(
        //               decoration: InputDecoration(
        //                 labelText: 'Start Date',
        //                 border: OutlineInputBorder(
        //                   borderSide: BorderSide(
        //                     color: Pallete.paleblueColor,
        //                   ),
        //                 ),
        //                 filled: true,
        //                 fillColor: Pallete.palegrayColor,
        //                 suffixIcon: Icon(Icons.calendar_today),
        //               ),
        //               readOnly: true,
        //               onTap: () {
        //                 showDatePicker(
        //                   context: context,
        //                   initialDate: DateTime.now(),
        //                   firstDate: DateTime.now(),
        //                   lastDate: DateTime.now().add(Duration(days: 365)),
        //                 ).then((selectedDate) {
        //                   if (selectedDate != null) {
        //                     setState(() {
        //                       _selectedStartDate = selectedDate;
        //                     });
        //                   }
        //                 });
        //               },
        //               controller: TextEditingController(
        //                  // ignore: unnecessary_null_comparison
        //                  text: _selectedEndDate != null
        //                             ? _selectedEndDate
        //                                 .toLocal()
        //                                 .toString()
        //                                 .split(' ')[0]
        //                             : '',
        //               ),
        //             ),
        //           ),
        //           SizedBox(width: 20),
        //           Expanded(
        //             child: TextFormField(
        //               decoration: InputDecoration(
        //                 labelText: 'End Date',
        //                 border: OutlineInputBorder(
        //                   borderSide: BorderSide(
        //                     color: Pallete.paleblueColor,
        //                   ),
        //                 ),
        //                 filled: true,
        //                 fillColor: Pallete.palegrayColor,
        //                 suffixIcon: Icon(Icons.calendar_today),
        //               ),
        //               readOnly: true,
        //               onTap: () {
        //                 showDatePicker(
        //                   context: context,
        //                   initialDate: _selectedStartDate ?? DateTime.now(),
        //                   firstDate: _selectedStartDate ?? DateTime.now(),
        //                   lastDate: DateTime.now().add(Duration(days: 365)),
        //                 ).then((selectedDate) {
        //                   if (selectedDate != null) {
        //                     setState(() {
        //                       _selectedEndDate = selectedDate;
        //                     });
        //                   }
        //                 });
        //               },
        //               controller: TextEditingController(
        //                 text: _selectedEndDate != null
        //                     ? _selectedEndDate!
        //                         .toLocal()
        //                         .toString()
        //                         .split(' ')[0]
        //                     : '',
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       ElevatedButton(
        //         child: Text('Submit'),
        //         onPressed: () {
        //           if (_formKey.currentState!.validate()) {
        //             _formKey.currentState!.save();
        //             // _medicine.startDate = _selectedStartDate;
        //             // _medicine.endDate = _selectedEndDate;
        //             Provider.of<MedicineProvider>(context, listen: false)
        //                 .addMedicine(_medicine);
        //             Navigator.pop(context);
        //           }
        //         },
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Pallete.mainColor,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(15.0),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
