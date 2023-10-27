import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/HealthRecordModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Info extends StatefulWidget {
  final Patient patient;
  const Info({super.key, required this.patient});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late Future<List<Prescription>> prescriptions;
  late Future<List<Account>> physicians;
  HealthRecord? record;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrescriptionProvider>(context, listen: false);
    provider.fetchPrescriptions(widget.patient.patientId);
    prescriptions = provider.prescriptions;
    physicians = provider.physicians;
    return FutureBuilder(
      future: provider.prescriptions,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No data available'),
          );
        } else {
          final prescriptionList = snapshot.data;

          return ListView.builder(
            itemCount: prescriptionList!.length,
            itemBuilder: (context, index) {
              final prescription = prescriptionList[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                      'Prescription Number: ${prescription.prescriptions}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: prescription.prescriptions!.map((medicine) {
                      return Text(
                        'Medicine: ${medicine.name}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
