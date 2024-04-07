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
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/PatientTabsScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/widgets/AddMedicineDialog.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/widgets/MedicineCard.dart';
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
  late String token = context.read<AccountProvider>().token!;
  late Future<List<Prescription>> prescriptions;
  late bool _autoValidate = false;
  late String? prescriptID;
  final _presIllnessInfoFormKey = GlobalKey<FormState>();
  final DateTime? updatedAt = DateTime.now();

  var incompleteInputs = dangerSnackbar('${Strings.incompleteInputs}');
  var failedUpdateComplaint = dangerSnackbar('${Strings.dangerAdd} diagnosis.');
  var successfulUpdateComplaint =
      successSnackbar('${Strings.successfulUpdate} diagnosis.');

  int currentStep = 0;
  int? maxLines = 4;
  bool checkboxValue1 = false;
  bool _isLoading = false;

  void _onSubmit() async {
    setState(() => _isLoading = true);
    final isValid = _presIllnessInfoFormKey.currentState!.validate();

    if (!isValid) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(incompleteInputs);

      return;
    } else {
      final accountID = context.read<AccountProvider>().id;
      final token = context.read<AccountProvider>().token!;
      final patientID = widget.patient.patientID;
      final presentIllnessProvider =
          Provider.of<PresentIllnessProvider>(context, listen: false);
      final medicineProvider =
          Provider.of<MedicineProvider>(context, listen: false);

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

      print('PRESCRIPTION ID ${prescriptID}');

      final recipeSuccess = await medicineProvider.updatePrescription(
          accountID, patientID, widget.presentIllness.illnessID, prescriptID);

      final presentIllnessSuccess =
          await presentIllnessProvider.updateComplaint(
              presentIllnessRecord, widget.patient.patientID, accountID, token);

      if (presentIllnessSuccess || recipeSuccess) {
        int routesCount = 0;

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
            if (routesCount < 3) {
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
  void initState() {
    super.initState();
    token = context.read<AccountProvider>().token!;
    final provider = Provider.of<PrescriptionProvider>(context, listen: false);
    prescriptions =
        provider.fetchPrescriptions(widget.patient.patientID, token);
    prescriptID = provider.presID ?? '';
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
            SizedBox(height: Sizing.sectionSymmPadding),
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
                ? EditPrescriptionSection(medicineProvider)
                : SizedBox(width: Sizing.spacing),
            SizedBox(height: Sizing.spacing),
            FormTextField(
              initialvalue: widget.presentIllness.treatment,
              onchanged: (value) => widget.presentIllness.treatment = value,
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
              value: '${widget.presentIllness.complaint}',
            ),
            SizedBox(height: Sizing.formSpacing / 2),
            TitleValueText(
              title: 'Findings: ',
              value: '${widget.presentIllness.findings}',
            ),
            SizedBox(height: Sizing.formSpacing / 2),
            TitleValueText(
              title: 'Diagnosis: ',
              value: '${widget.presentIllness.diagnosis}',
            ),
            SizedBox(height: Sizing.formSpacing / 2),
            TitleValueText(
              title: 'Treatment: ',
              value: '${widget.presentIllness.treatment}',
            ),
            SizedBox(height: Sizing.formSpacing / 2),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              child: FutureBuilder<List<Prescription>>(
                future: prescriptions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final prescriptions = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: prescriptions.length,
                      itemBuilder: (context, index) {
                        final prescription = prescriptions[index];
                        if (prescription.illnessID ==
                            widget.presentIllness.illnessID) {
                          // return MedicineCard(
                          //   medicine: prescription.medicines![index],
                          //   patient: widget.patient,
                          //   index: index,
                          // );

                          prescriptID = prescription.presID;
                          print(' crypto ${prescription.presID}');
                          return ListTile(
                            subtitle: Column(
                              children: medicineProvider.medicines
                                  .map(
                                    (medicine) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${medicine.drugCode}'),
                                        Text(
                                          '${medicine.quantity} x ${medicine.drugName}: ${medicine.instructions}',
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: Sizing.sectionSymmPadding),
          ],
        ),
      ),
    ];
  }

  Column EditPrescriptionSection(MedicineProvider medicineProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        medicineProvider.medicines.isNotEmpty
            ? Container(
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
                          borderRadius:
                              BorderRadius.circular(Sizing.borderRadius),
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
              )
            : Container(
                height: MediaQuery.of(context).size.height / 4,
                child: FutureBuilder<List<Prescription>>(
                  future: prescriptions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final prescriptions = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: prescriptions.length,
                        itemBuilder: (context, index) {
                          final prescription = prescriptions[index];
                          if (prescription.illnessID ==
                              widget.presentIllness.illnessID) {
                            return MedicineCard(
                              medicine: prescription.medicines![index],
                              patient: widget.patient,
                              index: index,
                            );
                          }
                          return SizedBox.shrink();
                        },
                      );
                    }
                  },
                ),
              ),
      ],
    );
  }
}
