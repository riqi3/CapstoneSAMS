import 'package:capstone_sams/providers/healthcheckprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/buildwidgets.dart';

class HealthCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Check'),
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
                          buildDropdown(['M', 'F'], provider.genderOption,
                              (value) => provider.setGenderOption(value))),
                      buildQuestion(
                          'What is the age of the patient?',
                          buildDropdownAge(
                              provider.age, (value) => provider.setAge(value))),
                      buildQuestion(
                          'What is the blood pressure of the patient?',
                          buildDropdown(
                              ['Low', 'Medium', 'High'],
                              provider.bloodPressureOption,
                              (value) =>
                                  provider.setBloodPressureOption(value))),
                      buildQuestion(
                          'What is the cholesterol level of the patient?',
                          buildDropdown(
                              ['Low', 'Medium', 'High'],
                              provider.cholesterolLevelOption,
                              (value) =>
                                  provider.setCholesterolLevelOption(value))),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await provider.sendDataToBackend();
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
            SizedBox(height: 16),
            Container(
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
                  final top3Predictions = provider.top3Predictions;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Results:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      for (var prediction in top3Predictions)
                        Text(
                          '${prediction['disease']}: ${prediction['probability']}',
                        ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print('Cancel button pressed');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Analyze Again'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle Use button
                              print('Use button pressed');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Use this'),
                          ),
                        ],
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
}
