import 'package:capstone_sams/screens/ehr-list/patient/order-entry/api/api_service.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/widgets/PrognosisUpdateDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_sams/providers/SymptomsFieldsProvider.dart';
import '../../../../constants/theme/pallete.dart';

class CpoeFormScreen extends StatelessWidget {
  final String initialPrediction;
  final double initialConfidence;

  CpoeFormScreen({
    required this.initialPrediction,
    required this.initialConfidence,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    String finalPrediction = initialPrediction;
    double finalConfidence = initialConfidence;

    Future<void> _handleAnalyzeAgain(BuildContext context) async {
      try {
        await ApiService.deleteLatestRecord();

        Provider.of<SymptomFieldsProvider>(context, listen: false).reset();
        Navigator.pop(context);
      } catch (error) {
        print('Failed to delete the latest record: $error');
      }
    }

    void _showPrognosisUpdateDialog(BuildContext context) async {
      final newPrognosis = await showDialog<String>(
        context: context,
        builder: (context) => PrognosisUpdateDialog(),
      );

      if (newPrognosis != null && newPrognosis.isNotEmpty) {
        finalPrediction = newPrognosis;
        finalConfidence = 0;
      }
    }

    return ListView(
      shrinkWrap: true,
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
                'Result:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                'Suspected Disease: \n $finalPrediction',
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
                      label: Text(
                        'Analyze Again',
                        style: TextStyle(
                          fontSize: 12.5,
                        ),
                      ),
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
                      label: Text(
                        'Change Value',
                        style: TextStyle(
                          fontSize: 12.5,
                        ),
                      ),
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
      ],
    );
  }
}
