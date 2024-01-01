import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:flutter/material.dart';

class PresentMedHistoryForm extends StatefulWidget {
  const PresentMedHistoryForm({Key? key}) : super(key: key);

  @override
  State<PresentMedHistoryForm> createState() => _PresentMedHistoryFormState();
}

class _PresentMedHistoryFormState extends State<PresentMedHistoryForm> {
  int currentStep = 0;
  TextEditingController chiefComplaintField = TextEditingController();
  TextEditingController findingsField = TextEditingController();
  TextEditingController diagnosisField = TextEditingController();
  TextEditingController treatmentField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: TitleAppBar(
          text: '',
          iconColorLeading: Pallete.whiteColor,
          iconColorTrailing: Pallete.whiteColor,
          backgroundColor: Pallete.mainColor,
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: Pallete.mainColor),
        ),
        child: ListView(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Present Illness Form',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
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
                            bool isLastStep =
                                (currentStep == getSteps().length - 1);
                            if (isLastStep) {
                              //Do something with this information
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
                            final isLastStep =
                                currentStep == getSteps().length - 1;
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
                                    child:
                                        Text(isLastStep ? 'Confirm' : 'Next'),
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
        content: Column(
          children: [
            MultilineFormField(
              labeltext: '',
              controller: chiefComplaintField,
            ),
          ],
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
        content: Column(
          children: [
            MultilineFormField(
              labeltext: '',
              controller: findingsField,
            ),
          ],
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
            MultilineFormField(
              labeltext: '',
              controller: diagnosisField,
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
        content: Column(
          children: [
            MultilineFormField(
              labeltext: '',
              controller: treatmentField,
            ),
          ],
        ),
      ),
    ];
  }
}

class CustomBtn extends StatelessWidget {
  final Function? callback;
  final Widget? title;
  CustomBtn({Key? key, this.title, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          color: Colors.blue,
          child: TextButton(
            onPressed: () => callback!(),
            child: title!,
          ),
        ),
      ),
    );
  }
}

class MultilineFormField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String labeltext;
  final TextEditingController? controller;
  const MultilineFormField({
    Key? key,
    this.onChanged,
    this.controller,
    required this.labeltext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: labeltext,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Pallete.primaryColor,
            ),
          ),
          filled: true,
          fillColor: Pallete.palegrayColor,
        ),
        controller: controller,
        onChanged: onChanged != null ? (v) => onChanged!(v) : null,
        maxLines: 10,
        keyboardType: TextInputType.text,
      ),
    );
  }
}
