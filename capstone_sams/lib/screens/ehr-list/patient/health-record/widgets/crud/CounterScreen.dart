import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/SearchAppBar.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/PatientTabsScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CounterScreen extends StatefulWidget {
  final Prescription prescription;
  final int index;
  final Account physician;
  final int? presNum;
  final Medicine medicine;
  final Patient patient;
  const CounterScreen({
    Key? key,
    required this.medicine,
    required this.prescription,
    required this.presNum,
    required this.index,
    required this.physician,
    required this.patient,
  }) : super(key: key);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  var _quantityState = false;
  late int _counter;
  late int? _quantity =
      widget.prescription.medicines![widget.index]['quantity'];
  late String? name;
  late String? drugId;
  late String? drugCode;
  late String? instructions;
  late DateTime? startDate;
  late DateTime? endDate;
  late int? quantity;
  late int updateQuantity;
  late List<dynamic>? medicines;
  late String token;

  @override
  void initState() {
    super.initState();
    token = context.read<AccountProvider>().token!;
    _counter = widget.prescription.medicines![widget.index]['quantity'] as int;
    name = widget.prescription.medicines![widget.index]['drugName'];
    drugId = widget.prescription.medicines![widget.index]['drugId'];
    drugCode = widget.prescription.medicines![widget.index]['drugCode'];
    instructions = widget.prescription.medicines![widget.index]['instructions'];
    startDate = DateTime.parse(
        widget.prescription.medicines![widget.index]['startDate']);
    endDate =
        DateTime.parse(widget.prescription.medicines![widget.index]['endDate']);
    quantity = widget.prescription.medicines![widget.index]['quantity'];
    medicines = widget.prescription.medicines;
  }

  void savePrescription() {
    updateQuantity = _counter;
    final selectedMedicineIndex = widget.index;
    List<dynamic> updatedMedicines = List.from(medicines!);

    print('get amount ${updateQuantity}');
    if (selectedMedicineIndex >= 0 &&
        selectedMedicineIndex < medicines!.length) {
      Medicine modifiedMedicine = Medicine(
        drugId: drugId,
        endDate: endDate,
        drugCode: drugCode,
        drugName: name,
        quantity: updateQuantity,
        startDate: startDate,
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
          account: widget.prescription.account,
          patientID: widget.prescription.patientID,
          health_record: widget.prescription.health_record,
          disease: widget.prescription.disease,
        ),
        widget.patient.patientId,
        token,
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

      const snackBar = SnackBar(
        backgroundColor: Pallete.successColor,
        content: Text(
          'Updated the medicine amount',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isCounterZero = _counter == 0;
    bool isCounterAtQuantity = _counter == _quantity;
    double elementWidth = MediaQuery.of(context).size.width / 1.5;
    print(
        '${name}, ${drugId}, ${instructions}, ${startDate}, ${endDate}, ${drugCode}, QUANTITY ${_quantity}');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizing.headerHeight),
        child: SearchAppBar(
          backgroundColor: Pallete.mainColor,
          iconColorLeading: Pallete.whiteColor,
          iconColorTrailing: Pallete.whiteColor,
        ),
      ),
      endDrawer: ValueDashboard(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: Sizing.sectionSymmPadding),
          child: Material(
            elevation: Sizing.cardElevation,
            borderRadius: BorderRadius.all(
              Radius.circular(Sizing.borderRadius),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Pallete.mainColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Sizing.borderRadius),
                        topLeft: Radius.circular(Sizing.borderRadius)),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizing.sectionSymmPadding),
                  width: MediaQuery.of(context).size.width,
                  height: Sizing.cardContainerHeight,
                  child: Text(
                    'Medication Information',
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: Sizing.header3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Sizing.borderRadius),
                      bottomRight: Radius.circular(Sizing.borderRadius)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Pallete.whiteColor,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(Sizing.borderRadius),
                          bottomLeft: Radius.circular(Sizing.borderRadius)),
                    ),
                    padding: const EdgeInsets.all(
                      Sizing.sectionSymmPadding,
                    ),
                    child: Column(
                      children: [
                        DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Expanded(
                                child: Text('TITLE'),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text('VALUE'),
                              ),
                            ),
                          ],
                          rows: <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Drug Name')),
                                DataCell(Text('${name}')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Drug Code')),
                                DataCell(Text('${drugCode}')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Start Date')),
                                DataCell(Text('${startDate}')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('End Date')),
                                DataCell(Text('${endDate}')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Instructions')),
                                DataCell(Text('${instructions}')),
                              ],
                            ),
                            if (quantity == 0)
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text('Quantity')),
                                  DataCell(Text(
                                      '${widget.prescription.medicines![widget.index]['quantity']}')),
                                ],
                              ),
                          ],
                        ),
                        if (quantity != 0)
                          quantityCounter(
                            isCounterAtQuantity,
                            isCounterZero,
                            elementWidth,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding quantityCounter(
      bool isCounterAtQuantity, bool isCounterZero, double elementWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: Sizing.sectionSymmPadding),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 100,
                  height: 100,
                  child: Center(
                    child: isCounterAtQuantity || _quantityState
                        ? ElevatedButton(
                            onPressed: null, // Button disabled
                            child: const FaIcon(FontAwesomeIcons.plus),
                            style: ElevatedButton.styleFrom(
                              primary: Pallete.greyColor,
                              elevation: Sizing.cardElevation,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              minimumSize: Size(50, 50),
                            ),
                          )
                        : Increment(_incrementCounter),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 100,
                  height: 100,
                  // color: Colors.red,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Quantity',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizing.header4),
                      ),
                      Text(
                        '${_counter}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizing.header1),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 100,
                  height: 100,
                  child: Center(
                    child: isCounterZero || _quantityState
                        ? ElevatedButton(
                            onPressed: null, // Button disabled
                            child: const FaIcon(FontAwesomeIcons.minus),
                            style: ElevatedButton.styleFrom(
                              primary: Pallete.mainColor,
                              elevation: Sizing.cardElevation,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              minimumSize: Size(50, 50),
                            ),
                          )
                        : Decrement(_decrementCounter),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: savePrescription,
            child: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Pallete.mainColor,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              minimumSize: Size(30, elementWidth / 8),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton Decrement(void Function() _decrementCounter) {
    return ElevatedButton(
      onPressed: () {
        if (_counter == 0) {
          setState(() => _quantityState = true);
        } else {
          _decrementCounter();
        }
      },
      child: const FaIcon(FontAwesomeIcons.minus),
      style: ElevatedButton.styleFrom(
        primary: Pallete.mainColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        minimumSize: Size(50, 50),
      ),
    );
  }

  ElevatedButton Increment(void Function() _incrementCounter) {
    return ElevatedButton(
      onPressed: () {
        if (_counter >= _quantity!) {
          setState(() => _quantityState = true);
        } else {
          _incrementCounter();
        }
      },
      child: const FaIcon(FontAwesomeIcons.plus),
      style: ElevatedButton.styleFrom(
        primary: Pallete.mainColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        minimumSize: Size(50, 50),
      ),
    );
  }

  // ElevatedButton Decrement(void _decrementCounter()) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       if (_counter == 1) {
  //         print('below');
  //         setState(() => _quantityState = true);
  //         // if (_counter > 1) {
  //         //   setState(() => _quantityState = false);
  //         // }
  //       } else {
  //         _decrementCounter();
  //       }
  //     },
  //     child: const FaIcon(FontAwesomeIcons.minus),
  //     style: ElevatedButton.styleFrom(
  //       primary: Pallete.mainColor,
  //       elevation: 3,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(100.0),
  //       ),
  //       minimumSize: Size(50, 50),
  //     ),
  //   );
  // }

  // ElevatedButton Increment(void _incrementCounter()) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       if (_counter >= _quantity) {
  //         print('over');
  //         setState(() => _quantityState = true);
  //       } else {
  //         _incrementCounter();
  //       }
  //     },
  //     child: const FaIcon(FontAwesomeIcons.plus),
  //     style: ElevatedButton.styleFrom(
  //       primary: Pallete.mainColor,
  //       elevation: 3,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(100.0),
  //       ),
  //       minimumSize: Size(50, 50),
  //     ),
  //   );
  // }
}
