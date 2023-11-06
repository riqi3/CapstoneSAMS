import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/PatientTabsScreen.dart';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/Env.dart';
import '../../../../../constants/theme/pallete.dart';

class EditMedicineScreen extends StatefulWidget {
  final Medicine medicine;
  final Prescription? prescription;
  final int? presNum;
  final Patient patient;
  final int index;

  EditMedicineScreen(
      {required this.medicine,
      required this.prescription,
      required this.presNum,
      required this.patient,
      required this.index});

  @override
  _EditMedicineScreenState createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  late String? name;
  late String? drugId;
  late String? drugCode;
  late String? instructions;
  late DateTime? selectedStartDate;
  late DateTime? selectedEndDate;
  late int? quantity;

  late List<dynamic>? medicines;

  @override
  void initState() {
    super.initState();
    name = widget.medicine.drugName;
    drugId = widget.medicine.drugId;
    drugCode = widget.medicine.drugCode;
    instructions = widget.medicine.instructions;
    selectedStartDate = widget.medicine.startDate;
    selectedEndDate = widget.medicine.endDate;
    quantity = widget.medicine.quantity;
    medicines = widget.prescription?.medicines;
  }

  void savePrescription() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      // if (medicines != null && widget.prescription != null) {
      final selectedMedicineIndex = widget.index;

      List<dynamic> updatedMedicines = List.from(medicines!);

      if (selectedMedicineIndex >= 0 &&
          selectedMedicineIndex < updatedMedicines.length) {
        Medicine modifiedMedicine = Medicine(
          drugId: drugId,
          endDate: selectedEndDate,
          drugCode: drugCode,
          drugName: name,
          quantity: quantity,
          startDate: selectedStartDate,
          instructions: instructions,
        );

        updatedMedicines[selectedMedicineIndex] = modifiedMedicine;
        print('list ${updatedMedicines}');

        final provider =
            Provider.of<PrescriptionProvider>(context, listen: false);
        provider.updatePrescription(
          Prescription(
            presNum: widget.presNum,
            medicines: updatedMedicines,
            account: widget.prescription!.account,
            patientID: widget.prescription!.patientID,
            health_record: widget.prescription!.health_record,
            disease: widget.prescription!.disease,
          ),
          widget.patient.patientId,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientTabsScreen(
              patient: widget.patient,
              index: widget.index,
            ),
          ),
        );
      }
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Medication Order'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizing.sectionSymmPadding),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                              queryParameters: {"filter": filter},
                            );
                            // var models = Medicine.fromJson(response.data);
                            var models = List<Medicine>.from(response.data
                                .map((json) => Medicine.fromJson(json)));
                            return models;
                          },
                          itemAsString: (Medicine medicine) =>
                              medicine.drugName.toString(),
                          onChanged: (Medicine? data) => setState(() {
                            this.drugId = data?.drugId.toString();
                            this.name = data?.drugName.toString();
                            this.drugCode = data?.drugCode.toString();
                          }),
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
                            onChanged: (value) => setState(() {
                              this.instructions = value;
                            }),
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
                                        selectedStartDate = selectedDate;
                                      });
                                    }
                                  });
                                },
                                controller: TextEditingController(
                                  text: selectedStartDate != null
                                      ? selectedStartDate!
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
                                        selectedStartDate ?? DateTime.now(),
                                    firstDate:
                                        selectedStartDate ?? DateTime.now(),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 365)),
                                  ).then((selectedDate) {
                                    if (selectedDate != null) {
                                      setState(() {
                                        selectedEndDate = selectedDate;
                                      });
                                    }
                                  });
                                },
                                controller: TextEditingController(
                                  text: selectedEndDate != null
                                      ? selectedEndDate!
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
                                onChanged: (value) => setState(() {
                                  this.quantity = int.tryParse(value);
                                }),
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
                              onPressed: savePrescription,
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
      ),
    );
  }
}
