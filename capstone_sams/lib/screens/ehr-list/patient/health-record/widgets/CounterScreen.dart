import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/SearchAppBar.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CounterScreen extends StatefulWidget {
  final Prescription prescription;
  final int index;
  const CounterScreen({
    Key? key,
    required this.prescription,
    required this.index,
  }) : super(key: key);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  // final array = prescription.medicines[];
  @override
  Widget build(BuildContext context) {
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
                        fontWeight: FontWeight.w600),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.all(Sizing.sectionSymmPadding),
                //   alignment: Alignment.centerLeft,
                //   decoration: BoxDecoration(
                //     color: Pallete.whiteColor,
                //   ),
                //   child: Text(
                //     '${widget.prescription.medicines![widget.index]}',
                //     style: TextStyle(
                //         color: Pallete.mainColor,
                //         fontSize: Sizing.header4,
                //         fontWeight: FontWeight.w600),
                //   ),
                // ),
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
                                DataCell(Text(
                                    '${widget.prescription.medicines![widget.index]['drugName']}')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Drug Code')),
                                DataCell(Text(
                                    '${widget.prescription.medicines![widget.index]['drugCode']}')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Start Date')),
                                DataCell(Text(
                                    '${widget.prescription.medicines![widget.index]['startDate']}')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('End Date')),
                                DataCell(Text(
                                    '${widget.prescription.medicines![widget.index]['endDate']}')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Instructions')),
                                DataCell(Text(
                                    '${widget.prescription.medicines![widget.index]['instructions']}')),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: Plus(),
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
                                      '${widget.prescription.medicines![widget.index]['quantity']}',
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
                                  child: Subtract(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Text('${widget.prescription.medicines![widget.index]}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton Subtract() {
    return ElevatedButton(
      onPressed: () => {print('prev')},
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

  ElevatedButton Plus() {
    return ElevatedButton(
      onPressed: () => {print('next')},
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
}
