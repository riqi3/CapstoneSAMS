import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/PatientTabsScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/CounterScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/EditMedicineScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Info extends StatefulWidget {
  final Medicine medicine;
  final Account physician;
  final Patient patient;
  final String index;
  Info(
      {Key? key,
      required this.patient,
      required this.physician,
      required this.medicine,
      required this.index})
      : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late Future<List<Prescription>> prescriptions;
  late Future<List<Account>> physicians;

  @override
  void initState() {
    super.initState();
    prescriptions = fetchPrescriptions();
    physicians = fetchPhysicians();
  }

  Future<List<Prescription>> fetchPrescriptions() async {
    try {
      final provider =
          Provider.of<PrescriptionProvider>(context, listen: false);
      await provider.fetchPrescriptions(widget.patient.patientId);
      return provider.prescriptions;
    } catch (error, stackTrace) {
      print("Error fetching data: $error");
      print(stackTrace);
      return [];
    }
  }

  Future<List<Account>> fetchPhysicians() async {
    try {
      final provider =
          Provider.of<PrescriptionProvider>(context, listen: false);
      await provider.fetchPrescriptions(widget.patient.patientId);
      return provider.physicians;
    } catch (error, stackTrace) {
      print("Error fetching data: $error");
      print(stackTrace);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print(prescriptions);
    print('PASS ACCOUNT #${widget.index} TO INFO WIDGET');
    return Container(
      height: MediaQuery.of(context).size.height * .70,
      child: FutureBuilder<List<Prescription>>(
        future: prescriptions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.hasError}');
            return Text('Error: ${snapshot.hasError}');
          } else {
            final prescriptionList = snapshot.data;

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: prescriptionList!.length,
              itemBuilder: (context, index) {
                final prescription = prescriptionList[index];

                return prescription.account == widget.index
                    ? Card(
                        margin: EdgeInsets.only(
                          left: Sizing.sectionSymmPadding,
                          right: Sizing.sectionSymmPadding,
                          bottom: Sizing.sectionSymmPadding,
                        ),
                        child: ListTile(
                          title: Text(
                              'Prescription Number: ${prescription.presNum}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: prescription.medicines!.map((medicine) {
                              return Column(
                                children: [
                                  Text(
                                    'Medicine: ${medicine["drugName"]}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          trailing: popupActionWidget(
                              index, prescriptionList, prescription),
                        ),
                      )
                    : null;
              },
            );
          }
        },
      ),
    );
  }

  PopupMenuButton<dynamic> popupActionWidget(int index,
      List<Prescription> prescriptionList, Prescription prescription) {
    final accountProvider = Provider.of<AccountProvider>(context);
    if (accountProvider.role == 'nurse') {
      return nurseAction(
        index,
        prescriptionList,
        prescription,
      );
    }
    if (accountProvider.id != prescription.account) {
      return PopupMenuButton(itemBuilder: (context) => []);
    } else {
      return physicianAction(
        index,
        prescriptionList,
        prescription,
      );
    }
  }

  void deletePrescription(BuildContext context, Prescription prescription) {
    final provider = Provider.of<PrescriptionProvider>(context, listen: false);
    provider.removePrescription(prescription, widget.patient.patientId);
    // Navigator.of(context).pop();
    int? index = int.tryParse(widget.index);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientTabsScreen(
          patient: widget.patient,
          index: index!,
        ),
      ),
    );

    const snackBar = SnackBar(
      backgroundColor: Pallete.dangerColor,
      content: Text(
        'Deleted the prescription',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void deleteMedicine(
      BuildContext context, Prescription prescription, String? drugId) {
    final provider = Provider.of<PrescriptionProvider>(context, listen: false);
    provider.removeMedicine(prescription, widget.patient.patientId, drugId);

    int? index = int.tryParse(widget.index);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientTabsScreen(
          patient: widget.patient,
          index: index!,
        ),
      ),
    );

    const snackBar = SnackBar(
      backgroundColor: Pallete.dangerColor,
      content: Text(
        'Deleted the medicine',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void editPrescription(BuildContext context, Prescription prescription,
      int index, int? presNum) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditMedicineScreen(
          medicine: widget.medicine,
          patient: widget.patient,
          index: index,
          prescription: prescription,
          presNum: presNum,
        ),
      ),
    );
  }

  void prescriptionCounter(
      BuildContext context, Prescription prescription, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CounterScreen(
          prescription: prescription,
          index: index,
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> nurseAction(
    int index,
    List<Prescription> prescriptionList,
    Prescription prescription,
  ) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.pills,
              color: Pallete.infoColor,
            ),
            title: Text(
              'Manage',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Pallete.infoColor,
              ),
            ),
            onTap: () {
              print('${prescription.presNum} manage');

              if (prescription.medicines?.length == 1) {
                prescriptionCounter(context, prescription, index);
              } else {
                manageMedicineQuantity(context, prescription);
              }
            },
          ),
        ),
      ],
    );
  }

  Future<dynamic> manageMedicineQuantity(
      BuildContext context, Prescription prescription) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select a medicine to manage'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            prescription.medicines!.length,
            (medicineIndex) {
              final medicine = prescription.medicines![medicineIndex];
              return InkWell(
                onTap: () {
                  print('${medicine["drugName"]} ${medicineIndex}');

                  prescriptionCounter(context, prescription, medicineIndex);
                },
                child: ListTile(
                  title: Text('${medicine["drugName"]}'),
                ),
              );
            },
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  PopupMenuButton<dynamic> physicianAction(
    int index,
    List<Prescription> prescriptionList,
    Prescription prescription,
  ) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.pen,
              color: Pallete.successColor,
            ),
            title: Text(
              'Edit',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Pallete.successColor,
              ),
            ),
            onTap: () {
              print('${prescription.presNum} edit');

              if (prescription.medicines?.length == 0) {
                editPrescription(
                    context, prescription, index, prescription.presNum);
              } else {
                editPrescriptionDetails(context, prescription);
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.trash,
              color: Pallete.dangerColor,
            ),
            title: Text(
              'Delete',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Pallete.dangerColor,
              ),
            ),
            onTap: () {
              print('${prescription.presNum} delete');

              if (prescription.medicines?.length == 1) {
                deletePrescription(context, prescription);
              } else {
                deletePrescriptionDetails(context, prescription);
                // editPrescriptionDetails(context, prescription);
                // deleteMedicine(context, prescription, widget.medicine.drugId);
              }
            },
          ),
        ),
      ],
    );
  }

  Future<dynamic> editPrescriptionDetails(
      BuildContext context, Prescription prescription) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select a prescription to edit'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            prescription.medicines!.length,
            (medicineIndex) {
              final medicine = prescription.medicines![medicineIndex];
              return InkWell(
                onTap: () {
                  print('${medicine["drugName"]} ${medicineIndex}');
                  editPrescription(context, prescription, medicineIndex,
                      prescription.presNum);
                },
                child: ListTile(
                  title: Text('${medicine["drugName"]}'),
                ),
              );
            },
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> deletePrescriptionDetails(
      BuildContext context, Prescription prescription) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select a prescription to delete'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            prescription.medicines!.length,
            (medicineIndex) {
              // String? medIndex = medicineIndex.toString();
              final medicine = prescription.medicines![medicineIndex];
              return InkWell(
                onTap: () {
                  print(
                      '${medicine['drugId']} ${medicine["drugName"]} ${medicineIndex}');

                  // deletePrescription(context, prescription);
                  deleteMedicine(context, prescription, medicine['drugId']);
                },
                child: ListTile(
                  title: Text('${medicine["drugName"]}'),
                ),
              );
            },
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
