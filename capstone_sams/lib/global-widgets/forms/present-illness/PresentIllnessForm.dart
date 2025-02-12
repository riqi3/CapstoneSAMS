import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/buttons/FormSubmitButton.dart';
import 'package:capstone_sams/global-widgets/forms/FormTemplate.dart';
import 'package:capstone_sams/global-widgets/snackbars/Snackbars.dart';
import 'package:capstone_sams/global-widgets/text-fields/Textfields.dart';
import 'package:capstone_sams/global-widgets/texts/FormTitleWidget.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/HealthCheckProvider.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/PatientTabsScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/CpoeAnalyzeScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../healthcheckscreen.dart';

// ignore: must_be_immutable
class PresentIllnessForm extends StatefulWidget {
  Patient patient;
  PresentIllnessForm({
    Key? key,
    required this.patient,
  }) : super(key: key);

  @override
  State<PresentIllnessForm> createState() => _PresentMedHistoryFormState();
}

class _PresentMedHistoryFormState extends State<PresentIllnessForm> {
  final _presIllnessInfoFormKey = GlobalKey<FormState>();
  final _presIllnessInfo = PresentIllness();
  final DateTime? createdAt = DateTime.now();
  int currentStep = 0;
  int? maxLines = 4;

  var incompleteInputs = dangerSnackbar('${Strings.incompleteInputs}');
  var failedCreatedComplaint =
      dangerSnackbar('${Strings.dangerAdd} diagnosis.');
  var successfulCreatedComplaint =
      successSnackbar('${Strings.successfulAdd} diagnosis.');

  bool _isLoading = false;

  late bool _autoValidate = false;

  void _onSubmit() async {
    setState(() => _isLoading = true);
    final isValid = _presIllnessInfoFormKey.currentState!.validate();

    if (!isValid) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(incompleteInputs);

      return;
    } else {
      // String getDate = DateFormat.yMMMd('en_US').format(createdAt as DateTime);

      String formattedDate = createdAt != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(createdAt!)
          : '';

      var presentIllnessRecord = PresentIllness(
        illnessID: Uuid().v4(),
        illnessName: _presIllnessInfo.illnessName,
        complaint: _presIllnessInfo.complaint,
        findings: _presIllnessInfo.findings,
        diagnosis: _presIllnessInfo.diagnosis,
        treatment: _presIllnessInfo.treatment,
        created_at: formattedDate,
        // updated_at: formattedDate,
        patient: widget.patient.patientID,
      );

      final accountID = context.read<AccountProvider>().id;

      final presentIllnessProvider =
          Provider.of<PresentIllnessProvider>(context, listen: false);

      final token = context.read<AccountProvider>().token!;

      final presentIllnessSuccess =
          await presentIllnessProvider.createComplaint(
              presentIllnessRecord, token, widget.patient.patientID, accountID);

      if (presentIllnessSuccess) {
        int routesCount = 0;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PatientTabsScreen(patient: widget.patient),
          ),
          (Route<dynamic> route) {
            if (routesCount < 2) {
              routesCount++;
              return false;
            }
            return true;
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(successfulCreatedComplaint);
      } else {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(failedCreatedComplaint);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      onpressed: () => Navigator.pop(context),
      column: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormTitleWidget(title: 'Present Illness Form'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(primary: Pallete.mainColor),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: _presIllnessInfoFormKey,
                    autovalidateMode: _autoValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Stepper(
                      physics: BouncingScrollPhysics(),
                      type: StepperType.vertical,
                      currentStep: currentStep,
                      onStepCancel: () => currentStep == 0
                          ? null
                          : setState(() {
                              currentStep -= 1;
                            }),
                      onStepContinue: () {
                        bool isLastStep =
                            (currentStep == getSteps().length - 1);
                        if (isLastStep) {
                        } else {
                          setState(() {
                            currentStep += 1;
                          });
                        }
                      },
                      onStepTapped: (step) => setState(() {
                        currentStep = step;
                      }),
                      steps: getSteps(),
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        final isLastStep = currentStep == getSteps().length - 1;

                        return Row(
                          children: <Widget>[
                            if (currentStep != 0)
                              Expanded(
                                child: ElevatedButton(
                                  child: Text('Cancel'),
                                  onPressed: details.onStepCancel,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Pallete.greyColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Sizing.borderRadius),
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(width: Sizing.formSpacing),
                            Expanded(
                              child: FormSubmitButton(
                                title: isLastStep ? 'Submit' : 'Next',
                                icon: Icons.upload,
                                isLoading: _isLoading,
                                onpressed: isLastStep
                                    ? _isLoading
                                        ? null
                                        : _onSubmit
                                    : details.onStepContinue,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: Text(
          'Chief Complaint',
          style: TextStyle(
              color: Pallete.mainColor,
              fontSize: Sizing.header4,
              fontWeight: FontWeight.w600),
        ),
        content: FormTextField(
          onchanged: (value) => _presIllnessInfo.complaint = value,
          labeltext: '',
          validator: Strings.requiredField,
          maxlines: maxLines,
          type: TextInputType.text,
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: Text(
          'Findings',
          style: TextStyle(
              color: Pallete.mainColor,
              fontSize: Sizing.header4,
              fontWeight: FontWeight.w600),
        ),
        content: FormTextField(
          onchanged: (value) => _presIllnessInfo.findings = value,
          labeltext: '',
          validator: Strings.requiredField,
          maxlines: maxLines,
          type: TextInputType.text,
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: Text(
          'Diagnosis',
          style: TextStyle(
              color: Pallete.mainColor,
              fontSize: Sizing.header4,
              fontWeight: FontWeight.w600),
        ),
        content: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChangeNotifierProvider<HealthCheckProvider>(
                            create: (context) => HealthCheckProvider(),
                            child: HealthCheckScreen(),
                          );
                        },
                      ),
                    );
                  },
                  child: Text('EDP'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return CpoeAnalyzeScreen();
                        },
                      ),
                    );
                  },
                  child: Text('SDP'),
                ),
              ],
            ),
            FormTextField(
              onchanged: (value) => _presIllnessInfo.illnessName = value,
              labeltext: 'Illness Name*',
              validator: Strings.requiredField,
              type: TextInputType.text,
            ),
            SizedBox(height: Sizing.sectionSymmPadding),
            FormTextField(
              onchanged: (value) => _presIllnessInfo.diagnosis = value,
              labeltext: '',
              validator: Strings.requiredField,
              maxlines: maxLines,
              type: TextInputType.text,
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        title: Text(
          'Treatment',
          style: TextStyle(
              color: Pallete.mainColor,
              fontSize: Sizing.header4,
              fontWeight: FontWeight.w600),
        ),
        content: FormTextField(
          onchanged: (value) => _presIllnessInfo.treatment = value,
          labeltext: '',
          validator: Strings.requiredField,
          maxlines: maxLines,
          type: TextInputType.text,
        ),
      ),
    ];
  }
}
