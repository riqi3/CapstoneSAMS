import 'package:capstone_sams/global-widgets/forms/FormTemplate.dart';
import 'package:capstone_sams/global-widgets/texts/FormTitleWidget.dart';
import 'package:capstone_sams/models/SymptomsModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/SymptomsFieldsProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/CpoeFormScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/widgets/info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../constants/Env.dart';
import '../../../../constants/theme/pallete.dart';
import '../../../../constants/theme/sizing.dart';
import '../../../../models/PatientModel.dart';

class CpoeAnalyzeScreen extends StatefulWidget {
  final Patient patient;
  final String? initialComplaint;
  final String? initialFindings;
  final String? initialDiagnosis;
  final String? initialTreatment;
  CpoeAnalyzeScreen({
    required this.patient,
    this.initialComplaint,
    this.initialFindings,
    this.initialDiagnosis,
    this.initialTreatment,
  });

  @override
  _CpoeAnalyzeScreenState createState() => _CpoeAnalyzeScreenState();
}

class _CpoeAnalyzeScreenState extends State<CpoeAnalyzeScreen> {
  late String finalPrediction;
  late double finalConfidence;
  late String? _complaint;
  late String? _findings;
  late String? _diagnosis;
  late String? _treatment;
  @override
  void initState() {
    super.initState();
    Provider.of<SymptomFieldsProvider>(context, listen: false).resetState();
    _complaint = widget.initialComplaint;
    _findings = widget.initialFindings;
    _diagnosis = widget.initialDiagnosis;
    _treatment = widget.initialTreatment;
  }

  void _analyzeSymptoms() async {
    var symptomFieldsProvider =
        Provider.of<SymptomFieldsProvider>(context, listen: false);
    var accountProvider = Provider.of<AccountProvider>(context, listen: false);
    List<String> symptoms = symptomFieldsProvider.symptoms;

    if (symptoms.length < 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Insufficient Symptoms',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Pallete.mainColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Please add atleast 3 symptoms to analyze.'),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Pallete.mainColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      return;
    }

    try {
      var requestBody = {'symptoms': symptoms, 'accountID': accountProvider.id};

      var response = await http.post(
        Uri.parse('${Env.prefix}/cdss/create_symptom_record/'),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var prediction = jsonDecode(response.body) as Map<String, dynamic>;

        // Extract the final prediction and confidence
        finalPrediction = prediction['final_prediction'].toString();
        finalConfidence = prediction['final_confidence'] as double;
        if (finalPrediction.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CpoeFormScreen(
                patient: widget.patient,
                initialPrediction: finalPrediction,
                initialConfidence: finalConfidence,
                initialComplaint: _complaint,
                initialFindings: _findings,
                initialDiagnosis: _diagnosis,
                initialTreatment: _treatment,
              );
            },
          );
        }
        setState(() {});
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
    bool isAnalyzeButtonEnabled = symptomFieldsProvider.symptoms.length >= 1;

    return FormTemplate(
      onpressed: () => Navigator.pop(context),
      column: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FormTitleWidget(title: 'Symptom Disease Predictor'),
              SizedBox(height: 16),
              Row(
                children: [
                  MagnifyIconWidget(),
                  Text(
                    'Symptoms',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Pallete.mainColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _autocompleteFields.length,
                itemBuilder: (context, index) {
                  final widget = _autocompleteFields[index];
                  return Container(
                    color: index % 2 == 0 ? Colors.grey.shade200 : Colors.white,
                    child: widget,
                  );
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
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
                                          var symptomFieldsProvider = Provider
                                              .of<SymptomFieldsProvider>(
                                                  context,
                                                  listen: false);
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                String>.empty();
                                          }
                                          return listItems.where((String item) {
                                            return item.contains(
                                                    textEditingValue.text
                                                        .toLowerCase()) &&
                                                !symptomFieldsProvider.symptoms
                                                    .contains(item);
                                          });
                                        },
                                        onSelected: (String selectedItem) {
                                          symptomFieldsProvider.addSymptom(
                                              selectedItem, context);
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
                  SizedBox(width: 10),
                  Expanded(
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
        ],
      ),
    );
  }
}
