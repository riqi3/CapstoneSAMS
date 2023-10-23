import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/models/HealthRecordModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/HealthRecordProvider.dart';
import 'package:capstone_sams/providers/PatientProvider.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/PatientInfoCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/theme/sizing.dart';
import '../../../../models/PatientModel.dart';

class HealthRecordsScreen extends StatefulWidget {
  final Patient patient;

  const HealthRecordsScreen({super.key, required this.patient});

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  Future<List<Prescription>>? prescriptions;
  HealthRecord? record;
  // late int? presNumID;
  // late List? medicinesID;
  // late String? accID;
  // late int? healthRecordID;

  @override
  void initState() {
    super.initState();
    _initializeData();
    // context.read<HealthRecordProvider>().setRecord(widget.patient.patientId);
    // // record = context.read<HealthRecordProvider>().healthrecord;
    // print('health record num ${record.recordNum}');
    // prescriptions = context
    //     .read<PrescriptionProvider>()
    //     .fetchPrescriptions(record.recordNum!);

    // prescriptions = context
    //     .read<PrescriptionProvider>()
    //     .fetchPrescriptions(widget.patient.age + 69);
  }

  Future<void> _initializeData() async {
    await context
        .read<HealthRecordProvider>()
        .setRecord(widget.patient.patientId);
    record = context.read<HealthRecordProvider>().healthrecord;
    print(
        'Health record num ${record?.recordNum}'); // Use the null-aware operator !
    prescriptions = context
        .read<PrescriptionProvider>()
        .fetchPrescriptions(record?.recordNum);
  }

  // @override
  // void initState() {
  //   // final healthRecordID = context.read<HealthRecordProvider>().recordNum?.toInt();

  //   // medicinesID = context.read<PrescriptionProvider>().medicines;
  //   // accID = context.read<PrescriptionProvider>().acc;
  //   // healthRecordID = context.read<PrescriptionProvider>().healthRecord;
  // prescriptions =
  //     context.read<PrescriptionProvider>().fetchPrescriptions(100);
  //   // print('PREESCPTIONS ${prescriptions.}');

  //   super.initState();
  // }

  // widget.index.toString()
  @override
  Widget build(BuildContext context) {
    print('Patient ID: ${widget.patient.patientId}');
    // prescriptions =
    //     context.read<PrescriptionProvider>().fetchPrescriptions(100);
    // final presNumID = context.read<PrescriptionProvider>().presNum;
    //     print('PRESCRIPTION ID NUMBER ${presNumID}');
    // print('MEDICINES ID NUMBER ${medicinesID}');
    // print('ACCOUNT ID NUMBER ${accID}');
    // print('HEALTH RECORD ID NUMBER ${healthRecordID}');
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            PatientInfoCard(
              patient: widget.patient,
            ),
            // if (medicineProvider.medicines.isNotEmpty)
            // MedicationOrderCard(
            //   patient: widget.patient,
            // )
            // else
            //   SizedBox(),
            prescriptions != null
                ? FutureBuilder<List<Prescription>>(
                    future: prescriptions,
                    builder: (context, snapshot) {
                      List<Prescription> dataToShow = [];
                      if (snapshot.hasError) {
                        print(
                            'HEALTH RECORD snapshot error message: ${snapshot.error}');
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: const CircularProgressIndicator(),
                        );
                      } else if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(Strings.noPrescriptions),
                        );
                      } else if (snapshot.hasData) {
                        dataToShow = snapshot.data!;
                      }
                      return ListView.builder(
                          itemCount: dataToShow.length,
                          itemBuilder: (context, index) {
                            final a = dataToShow[index];
                            final b = a.presNum;
                            return ListTile(
                              title: Text(
                                b.toString(),
                              ),
                            );

                            // ExpansionTile(
                            //   title: Text('data'),
                            //   children: List.generate(
                            //       dataToShow.length, (index) => ListTile(
                            //         subtitle: b,
                            //       )),
                            // );
                          });
                      // MedicationOrderCard(
                      //   patient: widget.patient,
                      // );
                    },
                  )
                : const Text("No Prescriptions available"),
          ],
        ),
      ),
    );
  }
}
