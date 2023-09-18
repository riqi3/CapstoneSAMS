import 'package:capstone_sams/models/SymptomsModel.dart';
import 'package:capstone_sams/providers/SymptomsFieldsProvider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:capstone_sams/theme/pallete.dart';

import '../../../../constants/Env.dart';
import '../../../../models/PatientModel.dart';
import '../../../../theme/Sizing.dart';
import 'CpoeFormScreen.dart';

class CpoeAnalyzeScreen extends StatefulWidget {
  final int index;
  final Patient patient;
  CpoeAnalyzeScreen({
    required this.patient,
    required this.index,
  });

  @override
  _CpoeAnalyzeScreenState createState() => _CpoeAnalyzeScreenState();
}

class _CpoeAnalyzeScreenState extends State<CpoeAnalyzeScreen> {
  void _analyzeSymptoms() async {
    var symptomFieldsProvider =
        Provider.of<SymptomFieldsProvider>(context, listen: false);
    List<String> symptoms = symptomFieldsProvider.symptoms;

    try {
      var requestBody = {'symptoms': symptoms};

      var response = await http.post(
        Uri.parse('${Env.prefix}/predict/'),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var prediction = jsonDecode(response.body) as Map<String, dynamic>;

        // Extract the final prediction and confidence
        var finalPrediction = prediction['final_prediction'].toString();
        var finalConfidence = prediction['final_confidence'] as double;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CpoeFormScreen(
              patient: widget.patient,
              index: widget.index,
              finalPrediction: finalPrediction,
              finalConfidence: finalConfidence,
            ),
          ),
        );
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (error) {
      print('Caught an error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var symptomFieldsProvider = Provider.of<SymptomFieldsProvider>(context);
    List<Widget> _autocompleteFields = symptomFieldsProvider.autocompleteFields;
    bool isAddButtonEnabled = _autocompleteFields.length < 7;
    bool isAnalyzeButtonEnabled = symptomFieldsProvider.symptoms.length >= 3;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding * 2,
          bottom: Sizing.sectionSymmPadding * 4,
        ),
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          // margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(
            Sizing.sectionSymmPadding,
          ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Symptoms',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Pallete.mainColor),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _autocompleteFields.length,
                    itemBuilder: (context, index) {
                      final widget = _autocompleteFields[index];
                      return Container(
                        color: index % 2 == 0
                            ? Colors.grey.shade200
                            : Colors.white,
                        child: widget,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: isAddButtonEnabled
                          ? () {
                              symptomFieldsProvider.addSymptomField(
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Autocomplete<String>(
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                String>.empty();
                                          }
                                          return listItems.where((String item) {
                                            return item.contains(
                                                textEditingValue.text
                                                    .toLowerCase());
                                          });
                                        },
                                        onSelected: (String selectedItem) {
                                          symptomFieldsProvider
                                              .addSymptom(selectedItem);
                                        },
                                        fieldViewBuilder: (BuildContext context,
                                            TextEditingController
                                                textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted) {
                                          return TextFormField(
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            onFieldSubmitted: (String value) {
                                              onFieldSubmitted();
                                            },
                                          );
                                        },
                                        optionsViewBuilder:
                                            (BuildContext context,
                                                AutocompleteOnSelected<String>
                                                    onSelected,
                                                Iterable<String> options) {
                                          return Align(
                                            alignment: Alignment.topLeft,
                                            child: Material(
                                              elevation: 4.0,
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                children: options
                                                    .map((String option) =>
                                                        ListTile(
                                                          title: Text(option),
                                                          onTap: () {
                                                            onSelected(option);
                                                          },
                                                        ))
                                                    .toList(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        var index =
                                            _autocompleteFields.length - 1;
                                        if (index >= 0 &&
                                            index <
                                                symptomFieldsProvider
                                                    .symptoms.length) {
                                          var symptom = symptomFieldsProvider
                                              .symptoms[index];
                                          symptomFieldsProvider
                                              .removeSymptom(symptom);
                                        }
                                        symptomFieldsProvider
                                            .removeSymptomField(index);
                                      },
                                      icon: Icon(Icons.delete_rounded),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      child: Text('Add symptom',
                          style: TextStyle(color: Pallete.backgroundColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          isAnalyzeButtonEnabled ? _analyzeSymptoms : null,
                      child: Text(
                        'Analyze',
                        style: TextStyle(color: Pallete.backgroundColor),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
