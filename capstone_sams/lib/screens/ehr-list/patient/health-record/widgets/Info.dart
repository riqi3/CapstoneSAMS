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
  const Info({Key? key, required this.patient}) : super(key: key);

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
    return SizedBox(
      height: 300,
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
              itemCount: prescriptionList!.length,
              itemBuilder: (context, index) {
                final prescription = prescriptionList[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Prescription Number: ${prescription.account}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: prescription.medicines!.map((medicine) {
                        return Text(
                          'Medicine: ${medicine["name"]}',
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
      ),
    );
  }
}
