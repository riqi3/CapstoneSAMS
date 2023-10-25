import 'package:capstone_sams/providers/PatientProvider.dart';

import 'package:capstone_sams/screens/ehr-list/patient/health-record/PatientTabsScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/api/api_service.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/widgets/AddMedicineDialog.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/widgets/MedicineCard.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/widgets/PrognosisUpdateDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:capstone_sams/providers/SymptomsFieldsProvider.dart';

import '../../../../constants/theme/pallete.dart';
import '../../../../models/PatientModel.dart';
import '../../../../providers/AccountProvider.dart';
import '../../../../providers/MedicineProvider.dart';

class CpoeFormScreen extends StatelessWidget {
  final String finalPrediction;
  final double finalConfidence;
  final int index;
  final Patient patient;
  CpoeFormScreen({
    required this.patient,
    required this.index,
    required this.finalPrediction,
    required this.finalConfidence,
  });
  Future<void> _handleAnalyzeAgain(BuildContext context) async {
    try {
      await ApiService.deleteLatestRecord();

      Provider.of<SymptomFieldsProvider>(context, listen: false).reset();
      Navigator.pop(context);
    } catch (error) {
      // Handle the case where the record deletion fails
      // You can display an error message or perform any necessary actions here
      print('Failed to delete the latest record: $error');
    }
  }

  void _showPrognosisUpdateDialog(BuildContext context) async {
    final newPrognosis = await showDialog<String>(
      context: context,
      builder: (context) => PrognosisUpdateDialog(),
    );

    if (newPrognosis != null && newPrognosis.isNotEmpty) {}
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Analyze Page'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Diagnosis',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Prognosis: $finalPrediction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Confidence score: ${finalConfidence.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleAnalyzeAgain(context),
                        icon: Icon(Icons.search),
                        label: Text('Analyze Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Pallete.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showPrognosisUpdateDialog(context),
                        icon: Icon(Icons.edit),
                        label: Text('Change Value'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Pallete.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Physician Order',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (medicineProvider.medicines.isEmpty)
                  Text(
                    '\n\nNo current orders\n\n',
                    style: TextStyle(color: Pallete.greyColor),
                  )
                else
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: medicineProvider.medicines.length,
                        itemBuilder: (ctx, index) => MedicineCard(
                          medicine: medicineProvider.medicines[index],
                          index: index,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Comment Section',
                        style: TextStyle(
                            color: Pallete.paleblueColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF9EC6FA)),
                          ),
                          filled: true,
                          fillColor: Pallete.palegrayColor,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                         var accountID = context.read<AccountProvider>().id;
                        // final patientID =
                        //     context.read<PatientProvider>().fetchPatient(index.toString());
                         
                         var patient = await context
                            .read<PatientProvider>()
                            .fetchPatient(index.toString());
                         var patientID = patient.patientId;
                        var medicineProvider =
                            context.read<MedicineProvider>();
                        var success = await medicineProvider
                            .saveToPrescription(accountID, patientID);

                        print('PATIENT $patientID ACCOUNT $accountID');

                        print('TESTING PO ITO SA SUCCESS $success');

                        print(success);

                        if (success) {
                          print('test this selected PATIENT $index');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PatientTabsScreen(
                                patient: patient, 
                                index: index,
                              ),
                            ),
                          );
                        } else {
                          print("Failed to save prescription.");
                        }
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) => AddMedicineDialog(),
                      ),
                      icon: Icon(Icons.edit),
                      label: Text('Write Rx'),
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
    );
  }
}
