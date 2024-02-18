import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/global-widgets/forms/widgets/changevaluedialog.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/providers/healthcheckprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/AccountProvider.dart';
import 'present-illness/PresentIllnessForm.dart';
import 'widgets/buildwidgets.dart';

// ignore: must_be_immutable
class HealthCheckScreen extends StatelessWidget {
  final void Function(String)? onDiseaseSelected;
  final Patient patient;

  HealthCheckScreen({required this.patient, this.onDiseaseSelected});
  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluation Disease Predictor'),
        backgroundColor: Pallete.mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Container(
              width: 450,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Consumer<HealthCheckProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildQuestion(
                          'Does the patient have fever?',
                          buildDropdown(['Yes', 'No'], provider.feverOption,
                              (value) => provider.setFeverOption(value))),
                      buildQuestion(
                          'Does the patient have cough?',
                          buildDropdown(['Yes', 'No'], provider.coughOption,
                              (value) => provider.setCoughOption(value))),
                      buildQuestion(
                          'Does the patient have fatigue?',
                          buildDropdown(['Yes', 'No'], provider.fatigueOption,
                              (value) => provider.setFatigueOption(value))),
                      buildQuestion(
                          'Is the patient experiencing difficulty in breathing?',
                          buildDropdown(
                              ['Yes', 'No'],
                              provider.difficultyBreathingOption,
                              (value) => provider
                                  .setDifficultyBreathingOption(value))),
                      buildQuestion(
                          'What is the gender of the patient?',
                          buildDropdown(
                              ['Male', 'Female'],
                              provider.genderOption,
                              (value) => provider.setGenderOption(value))),
                      buildQuestion(
                          'What is the age of the patient?',
                          buildDropdownAge(
                              provider.age, (value) => provider.setAge(value))),
                      buildQuestion(
                          'What is the blood pressure of the patient?',
                          buildDropdown(
                              ['Low', 'Normal', 'High'],
                              provider.bloodPressureOption,
                              (value) =>
                                  provider.setBloodPressureOption(value))),
                      buildQuestion(
                          'What is the cholesterol level of the patient?',
                          buildDropdown(
                              ['Low', 'Normal', 'High'],
                              provider.cholesterolLevelOption,
                              (value) =>
                                  provider.setCholesterolLevelOption(value))),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          String? token = accountProvider.token;
                          if (token != null) {
                            await provider.sendDataToBackend(token);
                            _showResultPopup(context, provider);
                          } else {
                            print('Token is null');
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? firstResultDisease;

  void _showResultPopup(BuildContext context, HealthCheckProvider provider) {
    onDiseaseSelected?.call('Selected Disease');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Result:',
            textAlign: TextAlign.center,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < provider.top3Predictions.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '${i == 0 && firstResultDisease != null ? firstResultDisease! : provider.top3Predictions[i]['disease']}: ${(provider.top3Predictions[i]['probability'] * 100).toInt()}%',
                            textAlign: TextAlign.center,
                            style: i == 0
                                ? TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black,
                                  )
                                : TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  _showChangeValueDialog(context, provider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(
                  'Change Value',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String selectedDisease =
                          provider.top3Predictions.first['disease'];
                      onDiseaseSelected?.call(selectedDisease);
                      provider.setFirstResultDisease(selectedDisease);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PresentIllnessForm(
                              patient: patient,
                              initialDisease: selectedDisease),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text('Use this',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text('Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  void _showChangeValueDialog(
      BuildContext context, HealthCheckProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return ChangeValueDialog(
          patient: patient,
          initialDisease: firstResultDisease ?? '',
        );
      },
    ).then((newDisease) {
      if (newDisease != null && newDisease != firstResultDisease) {
        // Update the first result disease if it's not null and changed
        firstResultDisease = newDisease;
        Navigator.of(context).pop();
        _showResultPopup(context, provider);
      }
    });
  }
}
