// DiagnosisAddiStepper.dart
import 'package:flutter/material.dart';

class DiagnosisSteps extends StatelessWidget {
  final int currentStep;
  final void Function(int) onStepTapped;
  final void Function() onStepContinue;
  final void Function() onStepCancel;

  DiagnosisSteps({
    required this.currentStep,
    required this.onStepTapped,
    required this.onStepContinue,
    required this.onStepCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Stepper(
      physics: BouncingScrollPhysics(),
      type: StepperType.vertical,
      currentStep: currentStep,
      onStepTapped: onStepTapped,
      onStepContinue: onStepContinue,
      onStepCancel: onStepCancel,
      steps: getDiagnosisSteps(),
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        // Customize controls as needed
        return Row(
          children: <Widget>[
            if (currentStep != 0)
              Expanded(
                child: ElevatedButton(
                  child: Text('Cancel'),
                  onPressed: details.onStepCancel,
                ),
              ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                child: Text('Next'),
                onPressed: details.onStepContinue,
              ),
            ),
          ],
        );
      },
    );
  }

  List<Step> getDiagnosisSteps() {
    return <Step>[
      Step(
        title: Text('Child Step 1'),
        content: TextField(),
      ),
      Step(
        title: Text('Child Step 2'),
        content: TextField(),
      ),
    ];
  }
}
