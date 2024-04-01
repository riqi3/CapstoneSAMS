import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/global-widgets/forms/present-illness/PresentIllnessForm.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:flutter/material.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/api/api_service.dart';

class PrognosisUpdateDialog extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final Patient patient;
  final String? initialComplaint;
  final String? initialFindings;
  final String? initialDiagnosis;
  final String? initialTreatment;
  PrognosisUpdateDialog(
      {required this.patient,
      this.initialComplaint,
      this.initialFindings,
      this.initialTreatment,
      this.initialDiagnosis});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Text(
        'Edit Suspected Disease',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Pallete.palegrayColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'New Disease',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final newPrognosis = controller.text;
                  final isSuccess =
                      await ApiService.updatePrognosis(context, newPrognosis);

                  if (isSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PresentIllnessForm(
                          patient: patient,
                          initialDisease: newPrognosis,
                          initialComplaint: initialComplaint,
                          initialFindings: initialFindings,
                          initialDiagnosis: initialDiagnosis,
                          initialTreatment: initialTreatment,
                        ),
                      ),
                    );
                  } else {
                    print('Failed to update diagnosis.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Submit and Use'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
