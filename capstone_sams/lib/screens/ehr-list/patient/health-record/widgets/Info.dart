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

  @override
  void initState() {
    super.initState();
    prescriptions = fetchData();
  }

  Future<List<Prescription>> fetchData() async {
    try {
      final provider = Provider.of<PrescriptionProvider>(context, listen: false);
      await provider.fetchPrescriptions(widget.patient.patientId);
      return provider.prescriptions;
    } catch (error) { 
      print("Error fetching data: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Prescription>>(
      future: fetchData(),
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
