import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/buttons/CancelButton.dart';
import 'package:capstone_sams/global-widgets/buttons/RadioTileButton.dart';
import 'package:capstone_sams/global-widgets/buttons/FormSubmitButton.dart';
import 'package:capstone_sams/global-widgets/chips/ListItemChips.dart';
import 'package:capstone_sams/global-widgets/datepicker/Datepicker.dart';
import 'package:capstone_sams/global-widgets/forms/FormTemplate.dart';
import 'package:capstone_sams/global-widgets/snackbars/Snackbars.dart';
import 'package:capstone_sams/global-widgets/text-fields/Textfields.dart';
import 'package:capstone_sams/global-widgets/texts/FormSectionTitleWidget.dart';
import 'package:capstone_sams/global-widgets/texts/FormTitleWidget.dart';
import 'package:capstone_sams/models/ContactPersonModel.dart';
import 'package:capstone_sams/models/MedicalRecordModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/ContactPersonProvider.dart';
import 'package:capstone_sams/providers/MedicalRecordProvider.dart';
import 'package:capstone_sams/providers/PatientProvider.dart';
import 'package:capstone_sams/screens/ehr-list/EhrListScreen.dart';
import 'package:capstone_sams/global-widgets/dropdown/MultiSelect.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PatientRegistrationForm extends StatefulWidget {
  final String? course;

  const PatientRegistrationForm({
    super.key,
    this.course,
  });

  @override
  State<PatientRegistrationForm> createState() =>
      _PatientRegistrationFormState();
}

class _PatientRegistrationFormState extends State<PatientRegistrationForm> {
  final _genInfoFormKey = GlobalKey<FormState>();
  final _genInfo = Patient();
  final _contactInfoFormKey = GlobalKey<FormState>();
  final _contactInfo = ContactPerson();

  var incompleteInputs = dangerSnackbar('${Strings.incompleteInputs}');
  var successfulRegisterPatient =
      successSnackbar('${Strings.successfulAdd} patient.');

  TextEditingController otherIllnesses = TextEditingController();
  TextEditingController otherAllergies = TextEditingController();
  TextEditingController otherPastDiseases = TextEditingController();
  TextEditingController otherFamHistory = TextEditingController();
  TextEditingController lmp = TextEditingController();
  TextEditingController firstAddress = TextEditingController();
  TextEditingController secondAddress = TextEditingController();

  List<String> _selectedAllergy = [];
  List<String> _selectedFamHistory = [];
  List<String> _selectedPastDiseases = [];
  List<String> _selectedIllnesses = [];

  bool _isPastDiseaseInvalid = false;
  bool _isFamHistoryInvalid = false;
  bool _isAllergyInvalid = false;
  bool _isIllnessInvalid = false;
  bool _isGenderInvalid = false;
  bool _isBirthdateInvalid = false;
  bool _isLoading = false;

  late bool _autoValidate = false;
  // late int? getAccountID = 0;
  late String tokena = context.read<AccountProvider>().token!;

  DateTime? _birthDate;
  final currentDate = DateTime.now();
  String? _selectedGender = '';
  List<String> statusList = [
    'Single',
    'Married',
    'Divorced',
    'Separated',
    'Widowed'
  ];

  void _onSubmit() async {
    setState(() => _isLoading = true);
    final isValid1 = _genInfoFormKey.currentState!.validate();
    final isValid2 = _contactInfoFormKey.currentState!.validate();

    if (!isValid1 ||
        !isValid2 ||
        // getAccountID == 0 ||
        _selectedPastDiseases.isEmpty ||
        _selectedFamHistory.isEmpty ||
        _selectedAllergy.isEmpty ||
        _selectedIllnesses.isEmpty) {
      setState(() => _isLoading = false);

      updateInvalidState(_selectedGender == '', (bool value) {
        _isGenderInvalid = value;
      });
      updateInvalidState(_birthDate == null, (bool value) {
        _isBirthdateInvalid = value;
      });
      updateInvalidState(_selectedPastDiseases.isEmpty, (bool value) {
        _isPastDiseaseInvalid = value;
      });
      updateInvalidState(_selectedFamHistory.isEmpty, (bool value) {
        _isFamHistoryInvalid = value;
      });
      updateInvalidState(_selectedAllergy.isEmpty, (bool value) {
        _isAllergyInvalid = value;
      });
      updateInvalidState(_selectedIllnesses.isEmpty, (bool value) {
        _isIllnessInvalid = value;
      });
      // updateInvalidState(getAccountID == 0, (bool value) {
      //   _isPhysicianInvalid = value;
      // });

      ScaffoldMessenger.of(context).showSnackBar(incompleteInputs);

      return;
    } else {
      String formattedDate = _birthDate != null
          ? DateFormat('yyyy-MM-dd').format(_birthDate!)
          : '';

      var email = _genInfo.email == null
          ? _genInfo.email = 'None'
          : _genInfo.email.toString();
      var phone = _genInfo.phone == null
          ? _genInfo.phone = 'None'
          : _genInfo.phone.toString();

      var age = calculateAge(currentDate, _birthDate!);

      _appendToTextList(otherPastDiseases, _selectedPastDiseases);
      _appendToTextList(otherFamHistory, _selectedFamHistory);
      _appendToTextList(otherAllergies, _selectedAllergy);
      _appendToTextList(otherIllnesses, _selectedIllnesses);

      var patient = Patient(
        patientID: Uuid().v4(),
        firstName: _genInfo.firstName,
        middleInitial: _genInfo.middleInitial,
        lastName: _genInfo.lastName,
        age: age['years'],
        gender: _selectedGender,
        patientStatus: statustValue,
        birthDate: formattedDate,
        course: _genInfo.course,
        yrLevel: _genInfo.yrLevel,
        studNumber: _genInfo.studNumber,
        height: _genInfo.height,
        weight: _genInfo.weight,
        address: firstAddress.text,
        email: email,
        phone: phone,
        // assignedPhysician: getAccountID,
      );

      var medicalRecord = MedicalRecord(
        recordID: Uuid().v4(),
        pastDiseases: _selectedPastDiseases,
        familyHistory: _selectedFamHistory,
        allergies: _selectedAllergy,
        illnesses: _selectedIllnesses,
        lastMensPeriod: lmp.text,
        patient: patient.patientID,
      );

      var contactRecord = ContactPerson(
        contactID: Uuid().v4(),
        fullName: _contactInfo.fullName,
        phone: _contactInfo.phone,
        address: secondAddress.text,
        patient: patient.patientID,
      );

      final accountID = context.read<AccountProvider>().id;

      final patientRecordProvider =
          Provider.of<PatientProvider>(context, listen: false);
      final medicalRecordProvider =
          Provider.of<MedicalRecordProvider>(context, listen: false);
      final contactRecordProvider =
          Provider.of<ContactPersonProvider>(context, listen: false);
      final token = context.read<AccountProvider>().token!;
      final role = context.read<AccountProvider>().role!;
      final id = context.read<AccountProvider>().id!;

      final patientSuccess = await patientRecordProvider.createPatientRecord(
          patient, token, accountID, role, id);
      final medicalRecordSuccess =
          await medicalRecordProvider.createMedicalRecord(
        medicalRecord.patient,
        medicalRecord,
        token,
      );
      final contactSuccess = await contactRecordProvider.createContactRecord(
        contactRecord,
        patient.patientID,
        token,
      );

      if (patientSuccess == true || medicalRecordSuccess || contactSuccess) {
        int routesCount = 0;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => EhrListScreen(),
          ),
          (Route<dynamic> route) {
            if (routesCount < 2) {
              routesCount++;
              return false;
            }
            return true;
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(successfulRegisterPatient);
      } else {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context)
            .showSnackBar(dangerSnackbar('${patientSuccess.errorMessage}'));
      }
    }
  }

  void updateInvalidState(var condition, Function(bool) setStateFunction) {
    setState(() {
      setStateFunction(condition);
    });
  }

  void _selectPastDisease() async {
    List<String> pastDisease = [
      'N/A',
      'Asthma',
      'Hypertension',
      'Cancer',
      'Thyroid problem',
      'Eye problem',
      'Diabetes mellitus',
      'Other'
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(title: 'Past Disease', items: pastDisease);
      },
    );

    if (results != null) {
      setState(() {
        _selectedPastDiseases = results;
      });
    }
  }

  void _selectFamHistory() async {
    List<String> familyHistoryList = [
      'N/A',
      'Asthma',
      'Hypertension',
      'Cancer',
      'Thyroid problem',
      'Eye problem',
      'Diabetes mellitus',
      'Other'
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
            title: 'Family History Illnesses', items: familyHistoryList);
      },
    );

    if (results != null) {
      setState(() {
        _selectedFamHistory = results;
      });
    }
  }

  void _selectAllergy() async {
    List<String> allergyList = ['N/A', 'Food', 'Medicine', 'Other'];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(title: 'Allergy', items: allergyList);
      },
    );

    if (results != null) {
      setState(() {
        _selectedAllergy = results;
      });
      print('${_selectedAllergy}aadadd');
    }
  }

  void _selectIllnesses() async {
    List<String> illnessesList = [
      'N/A',
      'Asthma',
      'Hypertension',
      'Cancer',
      'Thyroid problem',
      'Eye problem',
      'Diabetes mellitus',
      'Other'
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(title: 'Illnesses', items: illnessesList);
      },
    );

    if (results != null) {
      setState(() {
        _selectedIllnesses = results;
      });
    }
  }

  void _appendToTextList(TextEditingController contoller, List<String> list) {
    String newText = contoller.text;

    if (newText.isNotEmpty) {
      setState(() {
        list.add(newText);
        contoller.clear();
      });
    }
  }

  Map<String, int> calculateAge(DateTime currentDate, DateTime birthDate) {
    int years = currentDate.year - birthDate.year;
    int months = currentDate.month - birthDate.month;
    int days = currentDate.day - birthDate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += (months < 0 ? 12 : 0);
    }

    if (days < 0) {
      final daysInPreviousMonth =
          DateTime(currentDate.year, currentDate.month - 1, 0).day;
      days += daysInPreviousMonth;
      months--;
    }

    return {'years': years, 'months': months, 'days': days};
  }

  late String statustValue = statusList.first;

  @override
  void dispose() {
    lmp.dispose();
    firstAddress.dispose();
    secondAddress.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      onpressed: () => Navigator.pop(context),
      column: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormTitleWidget(title: 'Patient Registration Form'),
          GenInfoFormSection(),
          MedicalInfoFormSection(),
          ContactInfoFormSection(),
          SubmitButton(),
        ],
      ),
    );
  }

  Padding SubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(top: Sizing.sectionSymmPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: CancelButton()),
          SizedBox(width: Sizing.formSpacing),
          Expanded(
            child: FormSubmitButton(
              title: 'Submit',
              icon: Icons.upload,
              isLoading: _isLoading,
              onpressed: _isLoading ? null : _onSubmit,
            ),
          ),
        ],
      ),
    );
  }

  Column GenInfoFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitleWidget(title: 'General Information'),
        Form(
          key: _genInfoFormKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) => _genInfo.lastName = value,
                      labeltext: 'Surname*',
                      validator: Strings.requiredField,
                      type: TextInputType.name,
                    ),
                  ),
                  SizedBox(width: Sizing.formSpacing),
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) => _genInfo.firstName = value,
                      labeltext: 'First Name*',
                      validator: Strings.requiredField,
                      type: TextInputType.name,
                    ),
                  ),
                  SizedBox(width: Sizing.formSpacing),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 60.0,
                    ),
                    child: FormTextField(
                      onchanged: (value) => _genInfo.middleInitial = value,
                      labeltext: 'M.I.*',
                      validator: Strings.requiredField,
                      type: TextInputType.name,
                      countertext: '',
                      maxlength: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Sizing.formSpacing),
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Status*',
                        style: TextStyle(
                          color: Pallete.greyColor,
                        ),
                      ),
                      Flexible(
                        child: DropdownMenu<String>(
                          hintText: 'Status*',
                          initialSelection: statustValue,
                          onSelected: (String? value) {
                            setState(() {
                              statustValue = value!;
                            });
                          },
                          dropdownMenuEntries: statusList
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: Sizing.formSpacing),
                  // Flexible(
                  //   child: FormTextField(
                  //     onchanged: (value) {
                  //       _genInfo.age = int.tryParse(value);
                  //     },
                  //     labeltext: 'Age*',
                  //     validator: Strings.requiredField,
                  //     type: TextInputType.number,
                  //   ),
                  // ),
                  // SizedBox(width: Sizing.formSpacing),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gender*',
                          style: TextStyle(
                            color: Pallete.greyColor,
                          ),
                        ),
                        RadioTileButton(
                          isInvalid: _isGenderInvalid,
                          title: 'Male',
                          value: 'M',
                          groupvalue: _selectedGender,
                          onchange: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        RadioTileButton(
                          isInvalid: _isGenderInvalid,
                          title: 'Female',
                          value: 'F',
                          groupvalue: _selectedGender,
                          onchange: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        Visibility(
                          visible: _isGenderInvalid,
                          child: Text(
                            Strings.requiredField,
                            style: TextStyle(color: Pallete.dangerColor),
                          ),
                        ),
                        // if (_selectedGender == null) Text('Select a gender'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Sizing.formSpacing),
              Flexible(
                child: Datepicker(
                  isInvalid: _isBirthdateInvalid,
                  title: 'Date of Birth*',
                  ontap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1930),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          _birthDate = selectedDate;
                        });
                      }
                    });
                  },
                  onchanged: (value) => _birthDate,
                  controller: TextEditingController(
                    text: _birthDate != null
                        ? '${DateFormat.yMMMd('en_US').format(_birthDate as DateTime)}'
                        : '',
                  ),
                ),
              ),
              Visibility(
                visible: _isBirthdateInvalid,
                child: Text(
                  Strings.requiredField,
                  style: TextStyle(color: Pallete.dangerColor),
                ),
              ),
              SizedBox(height: Sizing.formSpacing),
              Row(
                children: <Widget>[
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) {
                        _genInfo.course = value;
                      },
                      labeltext: 'Course*',
                      validator: Strings.requiredField,
                      type: TextInputType.text,
                    ),
                  ),
                  SizedBox(width: Sizing.formSpacing),
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) {
                        _genInfo.yrLevel = int.tryParse(value);
                      },
                      labeltext: 'Year*',
                      validator: Strings.requiredField,
                      type: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Sizing.formSpacing),
              Flexible(
                child: FormTextField(
                  onchanged: (value) => _genInfo.studNumber = value,
                  labeltext: 'Student Number*',
                  validator: Strings.requiredField,
                  type: TextInputType.number,
                ),
              ),
              SizedBox(height: Sizing.formSpacing),
              Flexible(
                child: FormTextField(
                  // onchanged: (value) => firstAddress = value,
                  labeltext: 'Current Address*',
                  validator: Strings.requiredField,
                  type: TextInputType.text,
                  maxlines: 4,
                  controller: firstAddress,
                ),
              ),
              SizedBox(height: Sizing.formSpacing),
              Row(
                children: <Widget>[
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) {
                        _genInfo.height = double.tryParse(value);
                      },
                      labeltext: 'Height* (cm)',
                      validator: Strings.requiredField,
                      type: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: Sizing.formSpacing),
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) {
                        _genInfo.weight = double.tryParse(value);
                      },
                      labeltext: 'Weight* (kg)',
                      validator: Strings.requiredField,
                      type: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Sizing.formSpacing),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      children: [
                        FormTextField(
                          onchanged: (value) => _genInfo.email = value,
                          labeltext: 'Active Email',
                          type: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Sizing.formSpacing),
                  Flexible(
                    child: Column(
                      children: [
                        FormTextField(
                          onchanged: (value) => _genInfo.phone = value,
                          labeltext: 'Contact Number',
                          maxlength: 11,
                          type: TextInputType.phone,
                        ),
                      ],
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

  Column MedicalInfoFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitleWidget(title: 'Medical Information'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Past Disease*',
              style: TextStyle(
                fontSize: Sizing.formTitle,
                color: Pallete.greyColor,
              ),
            ),
            Flexible(
              child: ElevatedButton.icon(
                icon: FaIcon(FontAwesomeIcons.circleChevronDown),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizing.borderRadius),
                  ),
                ),
                onPressed: _selectPastDisease,
                label: Text('Select Past Disease'),
              ),
            ),
            ListItemChip(list: _selectedPastDiseases),
            Visibility(
              visible: _isPastDiseaseInvalid,
              child: Text(
                '${Strings.checkboxSelect} past disease.',
                style: TextStyle(color: Pallete.dangerColor),
              ),
            ),
            if (_selectedPastDiseases.contains('Other'))
              FormTextField(
                labeltext: 'Other*',
                validator: '${Strings.textValidation2} past disease.',
                type: TextInputType.text,
                maxlines: 2,
                controller: otherPastDiseases,
              ),
            SizedBox(height: Sizing.formSpacing),
            Text(
              'Family History*',
              style: TextStyle(
                fontSize: Sizing.formTitle,
                color: Pallete.greyColor,
              ),
            ),
            Flexible(
              child: ElevatedButton.icon(
                icon: FaIcon(FontAwesomeIcons.circleChevronDown),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizing.borderRadius),
                  ),
                ),
                onPressed: _selectFamHistory,
                label: Text('Select Family History Illnesses'),
              ),
            ),
            ListItemChip(list: _selectedFamHistory),
            Visibility(
              visible: _isFamHistoryInvalid,
              child: Text(
                '${Strings.checkboxSelect} family history illness.',
                style: TextStyle(color: Pallete.dangerColor),
              ),
            ),
            if (_selectedFamHistory.contains('Other'))
              FormTextField(
                labeltext: 'Other*',
                validator: '${Strings.textValidation2} family history illness.',
                type: TextInputType.text,
                maxlines: 2,
                controller: otherFamHistory,
              ),
            SizedBox(height: Sizing.formSpacing),
            Text(
              'Allergy Type*',
              style: TextStyle(
                fontSize: Sizing.formTitle,
                color: Pallete.greyColor,
              ),
            ),
            Flexible(
              child: ElevatedButton.icon(
                icon: FaIcon(FontAwesomeIcons.circleChevronDown),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizing.borderRadius),
                  ),
                ),
                onPressed: _selectAllergy,
                label: Text('Select Allergy'),
              ),
            ),
            ListItemChip(list: _selectedAllergy),
            Visibility(
              visible: _isAllergyInvalid,
              child: Text(
                '${Strings.checkboxSelect} allergy.',
                style: TextStyle(color: Pallete.dangerColor),
              ),
            ),
            if (_selectedAllergy.contains('Other'))
              FormTextField(
                labeltext: 'Other*',
                validator: '${Strings.textValidation2} allergy.',
                type: TextInputType.text,
                maxlines: 2,
                controller: otherAllergies,
              ),
            SizedBox(height: Sizing.formSpacing),
            Text(
              'Illnesses*',
              style: TextStyle(
                fontSize: Sizing.formTitle,
                color: Pallete.greyColor,
              ),
            ),
            Flexible(
              child: ElevatedButton.icon(
                icon: FaIcon(FontAwesomeIcons.circleChevronDown),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizing.borderRadius),
                  ),
                ),
                onPressed: _selectIllnesses,
                label: Text('Select Illnesses'),
              ),
            ),
            ListItemChip(list: _selectedIllnesses),
            Visibility(
              visible: _isIllnessInvalid,
              child: Text(
                '${Strings.checkboxSelect} illness.',
                style: TextStyle(color: Pallete.dangerColor),
              ),
            ),
            if (_selectedIllnesses.contains('Other'))
              FormTextField(
                labeltext: 'Other*',
                validator: '${Strings.textValidation2} illness.',
                type: TextInputType.text,
                maxlines: 2,
                controller: otherIllnesses,
              ),
            SizedBox(height: Sizing.formSpacing),
            // if (_selectedGender == 'F')
            //   Flexible(
            //     child: FormTextField(
            //       labeltext: 'LMP (Last Menstrual Period)',
            //       type: TextInputType.text,
            //       controller: lmp,
            //     ),
            //   ),
          ],
        ),
      ],
    );
  }

  Column ContactInfoFormSection() {
    return Column(
      children: [
        FormSectionTitleWidget(
            title: 'Person to be notified in case of Emergency'),
        Form(
          key: _contactInfoFormKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: FormTextField(
                  onchanged: (value) => _contactInfo.fullName = value,
                  labeltext: 'Full Name*',
                  validator: Strings.requiredField,
                  type: TextInputType.name,
                ),
              ),
              SizedBox(height: Sizing.formSpacing),
              Flexible(
                child: FormTextField(
                  onchanged: (value) => _contactInfo.phone = value,
                  labeltext: 'Contact Number*',
                  maxlength: 11,
                  validator: Strings.requiredField,
                  type: TextInputType.phone,
                ),
              ),
              SizedBox(height: Sizing.formSpacing),
              Flexible(
                child: FormTextField(
                  // onchanged: (value) => secondAddress = value,
                  labeltext: 'Current Address*',
                  validator: Strings.requiredField,
                  type: TextInputType.text,
                  maxlines: 4,
                  controller: secondAddress,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizing.borderRadius),
                  ),
                ),
                onPressed: () {
                  if (firstAddress.text.isNotEmpty) {
                    secondAddress.text = firstAddress.text;
                  }
                },
                child: const Text('Same Address As Above'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Flexible otherTextField(TextEditingController controller) {
    return Flexible(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              alignLabelWithHint: true,
              labelText: 'Other',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Pallete.primaryColor,
                ),
              ),
              filled: true,
              fillColor: Pallete.palegrayColor,
            ),
            controller: controller,
            maxLines: 2,
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: Sizing.formSpacing),
        ],
      ),
    );
  }
}
