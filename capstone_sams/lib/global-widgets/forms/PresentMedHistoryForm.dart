import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/global-widgets/forms/FormTemplate.dart';
import 'package:capstone_sams/global-widgets/text-fields/Textfields.dart';
import 'package:capstone_sams/global-widgets/texts/FormSectionTitleWidget.dart';
import 'package:capstone_sams/global-widgets/texts/FormTitleWidget.dart';
import 'package:flutter/material.dart';

class PresentMedHistoryForm extends StatefulWidget {
  const PresentMedHistoryForm({Key? key}) : super(key: key);

  @override
  State<PresentMedHistoryForm> createState() => _PresentMedHistoryFormState();
}

class _PresentMedHistoryFormState extends State<PresentMedHistoryForm> {
  int currentStep = 0;
  int? maxLines = 4;
  TextEditingController chiefComplaintField = TextEditingController();
  TextEditingController findingsField = TextEditingController();
  TextEditingController diagnosisField = TextEditingController();
  TextEditingController treatmentField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
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
                      bool isLastStep = (currentStep == getSteps().length - 1);
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
                            child: ElevatedButton(
                              child: Text(isLastStep ? 'Confirm' : 'Next'),
                              onPressed: details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Pallete.mainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Sizing.borderRadius),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
          labeltext: '',
          validator: Strings.requiredField,
          type: TextInputType.text,
          maxlines: maxLines,
          controller: chiefComplaintField,
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
          labeltext: '',
          validator: Strings.requiredField,
          type: TextInputType.text,
          maxlines: maxLines,
          controller: findingsField,
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
        content: FormTextField(
          labeltext: '',
          validator: Strings.requiredField,
          type: TextInputType.text,
          maxlines: maxLines,
          controller: diagnosisField,
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
          labeltext: '',
          validator: Strings.requiredField,
          type: TextInputType.text,
          maxlines: maxLines,
          controller: treatmentField,
        ),
      ),
    ];
  }
}
