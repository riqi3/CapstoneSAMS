import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/HealthRecordModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/HealthRecordProvider.dart';
import 'package:capstone_sams/providers/PatientProvider.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/Info.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/DISCARD/MedicationOrdersCard.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/PatientInfoCard.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/PhysicianCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/theme/sizing.dart';
import '../../../../models/PatientModel.dart';

class HealthRecordsScreen extends StatefulWidget {
  final Patient patient;

  const HealthRecordsScreen({
    super.key,
    required this.patient,
  });

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Patient ID: ${widget.patient.patientId}');
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
            PhysicianCard(patient: widget.patient),
            Info(patient: widget.patient),
            PatientInfoCard(
              patient: widget.patient,
            ),

            // FutureBuilder(
            //   future: prescriptions,
            //   builder: (context, snapshot) {
            //     List<dynamic>? dataToShow = [];
            //     // int dataLength = 0;
            //     if (snapshot.hasError) {
            //       print(
            //           'HEALTH RECORD snapshot error message: ${snapshot.error}');
            //       return Center(
            //         child: Text('Error: ${snapshot.error}'),
            //       );
            //     } else if (snapshot.connectionState ==
            //         ConnectionState.waiting) {
            //       return Center(
            //         child: const CircularProgressIndicator(),
            //       );
            //     } else if (snapshot.data!.isEmpty) {
            //       return Center(
            //         child: Text(Strings.noPrescriptions),
            //       );
            //     } else if (snapshot.hasData) {
            //       dataToShow = snapshot.data;
            //     }
            //     return
            //         // MedicationOrderCard(
            //         //   patient: widget.patient,
            //         // );

            //         LayoutBuilder(
            //       builder: (BuildContext context, BoxConstraints constraints) {
            //         return ListView.builder(
            //           shrinkWrap: true,
            //           physics: const BouncingScrollPhysics(),
            //           itemCount: dataToShow!.length,
            //           itemBuilder: (context, index) {
            //             final a = dataToShow![index];
            //             return MedicationOrderCard(prescription: a);
            //             // _buildList(
            //             //   dataToShow[index],
            //             // );
            //           },
            //         );
            //       },
            //     );
            //   },
            // ),

            // prescriptions != null
            //     ? FutureBuilder<List<Prescription>>(
            //         future: prescriptions,
            //         builder: (context, snapshot) {
            //           List<Prescription> dataToShow = [];
            //           int dataLength = 0;
            //           if (snapshot.hasError) {
            //             print(
            //                 'HEALTH RECORD snapshot error message: ${snapshot.error}');
            //             return Center(
            //               child: Text('Error: ${snapshot.error}'),
            //             );
            //           } else if (snapshot.connectionState ==
            //               ConnectionState.waiting) {
            //             return Center(
            //               child: const CircularProgressIndicator(),
            //             );
            //           } else if (snapshot.data!.isEmpty) {
            //             return Center(
            //               child: Text(Strings.noPrescriptions),
            //             );
            //           } else if (snapshot.hasData) {
            //             dataToShow = snapshot.data!;
            //             dataLength = dataToShow.length;
            //           }
            // return LayoutBuilder(
            //   builder:
            //       (BuildContext context, BoxConstraints constraints) {
            //     return ListView.builder(
            //       shrinkWrap: true,
            //       physics: const BouncingScrollPhysics(),
            //       itemCount: dataLength,
            //       itemBuilder: (context, index) {
            //         return _buildList(
            //           // snapshot,
            //           // dataToShow,
            //           dataToShow[index],
            //         );
            //       },
            //     );
            //   },
            // );

            // MedicationOrderCard(patient: widget.patient);

            // MedicationOrderCard(
            //   patient: widget.patient,
            // );
            //         },
            //       )
            // : const Text("No Prescriptions available"),
          ],
        ),
      ),
    );
  }

  // Widget _buildList(List<Patient> list) {
  //   // final jsonList = list.medicines;
  //   // final prescriptionNum = list.presc;
  //   // final acc = list.accounts;

  //   return ExpansionTile(
  //     textColor: Pallete.mainColor,
  //     iconColor: Pallete.mainColor,
  //     collapsedIconColor: Pallete.greyColor,
  //     title: Text(
  //       ('${prescriptionNum} | ${acc}'),
  //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //     ),
  //     subtitle: GestureDetector(
  //       onTap: () {
  //         print('ss');
  //         showDialog(
  //           context: context,
  //           builder: (context) => Dialog(
  //             child: Padding(
  //               padding: const EdgeInsets.all(Sizing.sectionSymmPadding),
  //               child: Text(
  //                 ('Investigations: ${prescriptionNum}'),
  //                 style: TextStyle(fontSize: Sizing.header5),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //       child: Text(
  //         ('Investigations: ${prescriptionNum}'),
  //         // maxLines: 2,
  //         // overflow: TextOverflow.ellipsis,
  //       ),
  //     ),
  //   );
  // }
}
