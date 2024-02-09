import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/buttons/FormSubmitButton.dart';
import 'package:capstone_sams/global-widgets/forms/FormTemplate.dart';
import 'package:capstone_sams/global-widgets/forms/healthcheckscreen.dart';
import 'package:capstone_sams/global-widgets/snackbars/Snackbars.dart';
import 'package:capstone_sams/global-widgets/text-fields/Textfields.dart';
import 'package:capstone_sams/global-widgets/texts/FormTitleWidget.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/HealthCheckProvider.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/PatientTabsScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditPresentMedHistoryForm extends StatefulWidget {
  Patient patient;
  PresentIllness presentIllness;
  EditPresentMedHistoryForm({
    Key? key,
    required this.patient,
    required this.presentIllness,
  }) : super(key: key);

  @override
  State<EditPresentMedHistoryForm> createState() =>
      _PresentMedHistoryFormState();
}

class _PresentMedHistoryFormState extends State<EditPresentMedHistoryForm> {
  final _presIllnessInfoFormKey = GlobalKey<FormState>();
  // final _presIllnessInfo = PresentIllness();
  final DateTime? updatedAt = DateTime.now();
  int currentStep = 0;
  int? maxLines = 4;

  var incompleteInputs = dangerSnackbar('${Strings.incompleteInputs}');
  var failedUpdateComplaint = dangerSnackbar('${Strings.dangerAdd} diagnosis.');
  var successfulUpdateComplaint =
      successSnackbar('${Strings.successfulUpdate} diagnosis.');

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

      String formattedDate = updatedAt != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(updatedAt!)
          : '';

      var presentIllnessRecord = PresentIllness(
        illnessID: widget.presentIllness.illnessID,
        illnessName: widget.presentIllness.illnessName,
        complaint: widget.presentIllness.complaint,
        findings: widget.presentIllness.findings,
        diagnosis: widget.presentIllness.diagnosis,
        treatment: widget.presentIllness.treatment,
        created_at: widget.presentIllness.created_at,
        updated_at: formattedDate,
        patient: widget.patient.patientID,
      );

      final accountID = context.read<AccountProvider>().id;

      final presentIllnessProvider =
          Provider.of<PresentIllnessProvider>(context, listen: false);

      final token = context.read<AccountProvider>().token!;

      final presentIllnessSuccess =
          await presentIllnessProvider.updateComplaint(
              presentIllnessRecord, widget.patient.patientID, accountID, token);

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

        ScaffoldMessenger.of(context).showSnackBar(successfulUpdateComplaint);
      } else {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(failedUpdateComplaint);
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
          FormTitleWidget(title: 'Edit Present Illness Form'),
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
          initialvalue: widget.presentIllness.complaint,
          onchanged: (value) => widget.presentIllness.complaint = value,
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
          initialvalue: widget.presentIllness.findings,
          onchanged: (value) => widget.presentIllness.findings = value,
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
              child: Text('Evaluation'),
            ),
            FormTextField(
              initialvalue: widget.presentIllness.illnessName,
              onchanged: (value) => widget.presentIllness.illnessName = value,
              labeltext: 'Illness Name*',
              validator: Strings.requiredField,
              type: TextInputType.text,
            ),
            SizedBox(height: Sizing.sectionSymmPadding),
            FormTextField(
              initialvalue: widget.presentIllness.diagnosis,
              onchanged: (value) => widget.presentIllness.diagnosis = value,
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
          initialvalue: widget.presentIllness.treatment,
          onchanged: (value) => widget.presentIllness.treatment = value,
          labeltext: '',
          validator: Strings.requiredField,
          maxlines: maxLines,
          type: TextInputType.text,
        ),
      ),
    ];
  }
}
