import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';
import 'package:capstone_sams/providers/PatientProvider.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/EditMedicineScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Info extends StatefulWidget {
  late Medicine medicine;
  final Patient patient;
  final String index;
  Info(
      {Key? key,
      required this.patient,
      required this.medicine,
      required this.index})
      : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late Future<List<Prescription>> prescriptions;
  late Future<List<Account>> physicians;
  // List<Prescription> _physicianPrescriptions = [];

  @override
  void initState() {
    super.initState();
    prescriptions = fetchPrescriptions();
    physicians = fetchPhysicians();
    // _fetchWrittenPrescriptions();
  }

  // Future<void> _fetchWrittenPrescriptions() async {
  //   final provider = Provider.of<PrescriptionProvider>(context, listen: false);
  //   final patientID = context.read<PatientProvider>().id;
  //   await provider.fetchPrescriptions(patientID!);
  //   setState(() {
  //     _physicianPrescriptions = provider.prescripts;
  //   });
  // }

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
                final medicineProvider =
                    Provider.of<MedicineProvider>(context, listen: false);
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
                          trailing: popupAction(
                            index, 
                            prescription, 
                            medicineProvider,
                          ),
                        ),
                      )
                    : Text('');
              },
            );
          }
        },
      ),
    );
  }

  void editPrescription(
      BuildContext context, Prescription prescription, int index, int? presNum ) {
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

  PopupMenuButton<dynamic> popupAction(
    int index,
    // int? presNum,
    Prescription prescription,
    // Medicine medicine,
    MedicineProvider medicineProvider,
  ) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.pen,
              color: Pallete.greenColor,
            ),
            title: Text(
              'Edit',
              style: TextStyle(
                color: Pallete.greenColor,
              ),
            ),
            onTap: () {
              print('${prescription.presNum} edit');
              editPrescription(context, prescription, index, prescription.presNum);
              // showDialog(
              //   context: context,
              //   builder: (context) => EditMedicineScreen(
              //     medicine: medicine,
              //     patient: widget.patient,
              //     index: index,
              //   ),
              // );
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.trash,
              color: Pallete.redColor,
            ),
            title: Text(
              'Delete',
              style: TextStyle(color: Pallete.redColor),
            ),
            onTap: () {
              print('${prescription.presNum} delete');
              medicineProvider.removeMedicine(index);
            },
          ),
        ),
      ],
    );
  }
}
