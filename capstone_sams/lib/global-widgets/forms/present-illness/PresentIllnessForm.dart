import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/buttons/FormSubmitButton.dart';
import 'package:capstone_sams/global-widgets/forms/FormTemplate.dart';
import 'package:capstone_sams/global-widgets/snackbars/Snackbars.dart';
import 'package:capstone_sams/global-widgets/text-fields/Textfields.dart';
import 'package:capstone_sams/global-widgets/texts/FormTitleWidget.dart';
import 'package:capstone_sams/global-widgets/texts/TitleValueText.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/HealthCheckProvider.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/PatientTabsScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/CpoeAnalyzeScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/widgets/AddMedicineDialog.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/widgets/MedicineCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../healthcheckscreen.dart';

// ignore: must_be_immutable
class PresentIllnessForm extends StatefulWidget {
  final String? initialComplaint;
  final String? initialFindings;
  final String? initialTreatment;
  final String? initialDiagnosis;

  final String? initialDisease;
  Patient patient;
  PresentIllnessForm({
    Key? key,
    required this.patient,
    this.initialComplaint,
    this.initialFindings,
    this.initialTreatment,
    this.initialDiagnosis,
    this.initialDisease,
  }) : super(key: key);

  @override
  State<PresentIllnessForm> createState() => _PresentMedHistoryFormState();
}

class _PresentMedHistoryFormState extends State<PresentIllnessForm> {
  final findings = TextEditingController();
  String displayFindings = '';
  String? selectedDisease;
  final _presIllnessInfoFormKey = GlobalKey<FormState>();
  final _presIllnessInfo = PresentIllness();
  final DateTime? createdAt = DateTime.now();
  int currentStep = 0;
  int? maxLines = 4;
  late String token;
  late String illness_id;
  // final illness_id = Uuid().v4();
  var getID = '';
  var incompleteInputs = dangerSnackbar('${Strings.incompleteInputs}');
  var failedCreatedComplaint =
      dangerSnackbar('${Strings.dangerAdd} diagnosis.');
  var successfulCreatedComplaint =
      successSnackbar('${Strings.successfulAdd} diagnosis.');

  bool checkboxValue1 = false;
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
      final token = context.read<AccountProvider>().token!;
      final accountID = context.read<AccountProvider>().id;
      final medicineProvider = context.read<MedicineProvider>();

      final illnessProvider = context.read<PresentIllnessProvider>();
      final s = await illnessProvider.fetchComplaint(token, illnessProvider.id);
      var medicines = medicineProvider.medicines;
      final patientID = widget.patient.patientID;

      print('illnes form ${illness_id}');
      final recipeSuccess = await medicineProvider.saveToPrescription(
          accountID, patientID, token, s.illnessID);

      if (recipeSuccess || medicines.isEmpty) {
        int routesCount = 0;
        setState(() {
          illness_id = '';
          _presIllnessInfo.illnessID = illness_id;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PatientTabsScreen(
              patient: widget.patient,
              index: widget.patient.patientID,
              selectedPage: 2,
            ),
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

  TextEditingController _complaintController = TextEditingController();
  TextEditingController _findingsController = TextEditingController();
  TextEditingController _illnessNameController = TextEditingController();
  TextEditingController _diagnosisController = TextEditingController();
  TextEditingController _treatmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    token = context.read<AccountProvider>().token!;
    Provider.of<MedicineProvider>(context, listen: false).resetState();
    selectedDisease = widget.initialDisease;
    illness_id = Uuid().v4();
    _complaintController.text =
        widget.initialComplaint == null ? '' : widget.initialComplaint!;
    _findingsController.text =
        widget.initialFindings == null ? '' : widget.initialFindings!;
    _illnessNameController.text =
        selectedDisease == null ? '' : selectedDisease!;
    _diagnosisController.text =
        widget.initialDiagnosis == null ? '' : widget.initialDiagnosis!;
    _treatmentController.text =
        widget.initialTreatment == null ? '' : widget.initialTreatment!;
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _findingsController.dispose();
    _illnessNameController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    super.dispose();
  }

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
                      // onStepTapped: (step) => setState(() {
                      //   currentStep = step;
                      // }),
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
                            currentStep == 3
                                ? Expanded(
                                    child: FormSubmitButton(
                                      title: currentStep == 3 ? 'Next' : 'Next',
                                      icon: isLastStep
                                          ? Icons.upload
                                          : Icons.chevron_right,
                                      isLoading: _isLoading,
                                      onpressed: () {
                                        String formattedDate = createdAt != null
                                            ? DateFormat('yyyy-MM-dd HH:mm')
                                                .format(createdAt!)
                                            : '';

                                        print(
                                            'create illnes form ${illness_id}');

                                        var presentIllnessRecord =
                                            PresentIllness(
                                          illnessID: illness_id,
                                          illnessName:
                                              _illnessNameController.text,
                                          // _presIllnessInfo.illnessName,
                                          complaint: _complaintController.text,
                                          // _presIllnessInfo.complaint,
                                          findings: _findingsController.text,
                                          // _presIllnessInfo.findings,
                                          diagnosis: _diagnosisController.text,
                                          // _presIllnessInfo.diagnosis,
                                          treatment: _treatmentController.text,
                                          // _presIllnessInfo.treatment,
                                          created_at: formattedDate,
                                          // updated_at: formattedDate,
                                          patient: widget.patient.patientID,
                                        );
                                        final accountID =
                                            context.read<AccountProvider>().id;
                                        // final presentIllnessProvider =
                                        //     Provider.of<PresentIllnessProvider>(
                                        //         context, listen: true);
                                        final presentIllnessSuccess = context
                                            .read<PresentIllnessProvider>()
                                            .createComplaint(
                                                presentIllnessRecord,
                                                token,
                                                widget.patient.patientID,
                                                accountID);
                                        getID = presentIllnessRecord.illnessID!;
                                        print('GET THE ID ${getID}');
                                        setState(() {
                                          currentStep += 1;
                                          details.onStepContinue;
                                        });
                                      },
                                    ),
                                  )
                                : Expanded(
                                    child: FormSubmitButton(
                                      title: isLastStep ? 'Submit' : 'Next',
                                      icon: isLastStep
                                          ? Icons.upload
                                          : Icons.chevron_right,
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
    final medicineProvider =
        Provider.of<MedicineProvider>(context, listen: false);

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
          controller: _complaintController,
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
          controller: _findingsController,
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
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ChangeNotifierProvider<HealthCheckProvider>(
                              create: (context) => HealthCheckProvider(),
                              child: HealthCheckScreen(
                                patient: widget.patient,
                                initialComplaint: _presIllnessInfo.complaint,
                                initialFindings: _presIllnessInfo.findings,
                                initialDiagnosis: _presIllnessInfo.diagnosis,
                                initialTreatment: _presIllnessInfo.treatment,
                              ),
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
                            return CpoeAnalyzeScreen(
                              patient: widget.patient,
                              initialComplaint: _presIllnessInfo.complaint,
                              initialFindings: _presIllnessInfo.findings,
                              initialDiagnosis: _presIllnessInfo.diagnosis,
                              initialTreatment: _presIllnessInfo.treatment,
                            );
                          },
                        ),
                      );
                    },
                    child: Text('SDP'),
                  ),
                ],
              ),
            ),
            SizedBox(height: Sizing.formSpacing),
            FormTextField(
              controller: _illnessNameController,
              onchanged: (value) => _presIllnessInfo.illnessName = value,
              labeltext: 'Illness Name*',
              // initialvalue: selectedDisease,
              validator: Strings.requiredField,
              type: TextInputType.text,
            ),
            SizedBox(height: Sizing.sectionSymmPadding),
            FormTextField(
              controller: _diagnosisController,
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
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              value: checkboxValue1,
              onChanged: (bool? value) {
                setState(() {
                  checkboxValue1 = value!;
                });
              },
              title: const Text('Create Medication Order'),
            ),
            checkboxValue1 == true
                ? CreatePrescriptionSection(medicineProvider)
                : SizedBox(width: Sizing.spacing),
            SizedBox(height: Sizing.spacing),
            FormTextField(
              controller: _treatmentController,
              onchanged: (value) => _presIllnessInfo.treatment = value,
              labeltext: '',
              validator: Strings.requiredField,
              maxlines: maxLines,
              type: TextInputType.text,
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 4 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 4,
        title: Text(
          'Summary',
          style: TextStyle(
            color: Pallete.mainColor,
            fontSize: Sizing.header4,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          children: [
            SizedBox(height: Sizing.formSpacing),
            TitleValueText(
              title: 'Complaint: ',
              value: '${_complaintController.text}',
            ),
            SizedBox(height: Sizing.formSpacing / 2),
            TitleValueText(
              title: 'Findings: ',
              value: '${_findingsController.text}',
            ),
            SizedBox(height: Sizing.formSpacing / 2),
            TitleValueText(
              title: 'Diagnosis: ',
              value: '${_diagnosisController.text}',
            ),
            SizedBox(height: Sizing.formSpacing / 2),
            TitleValueText(
              title: 'Treatment: ',
              value: '${_treatmentController.text}',
            ),
            SizedBox(height: Sizing.formSpacing / 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: medicineProvider.medicines
                  .map(
                    (medicine) => Text(
                      '${medicine.quantity} x ${medicine.drugName}: ${medicine.instructions}',
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: Sizing.sectionSymmPadding),
          ],
        ),
      ),
    ];
  }

  Column CreatePrescriptionSection(MedicineProvider medicineProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(Sizing.sectionSymmPadding),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Pallete.lightGreyColor2,
            borderRadius: BorderRadius.circular(Sizing.borderRadius / 3),
          ),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => AddMedicineDialog(),
                ),
                icon: Icon(Icons.edit),
                label: Text('Write Rx'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizing.borderRadius),
                  ),
                ),
              ),
              if (medicineProvider.medicines.isEmpty)
                Text(
                  '\n\nNo current orders\n\n',
                  style: TextStyle(color: Pallete.greyColor),
                )
              else
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: medicineProvider.medicines.length,
                      itemBuilder: (ctx, index) => MedicineCard(
                        medicine: medicineProvider.medicines[index],
                        patient: widget.patient,
                        index: index,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
