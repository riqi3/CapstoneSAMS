import 'package:capstone_sams/constants/Env.dart';
import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/global-widgets/buttons/CancelButton.dart';
import 'package:capstone_sams/global-widgets/buttons/RadioTileButton.dart';
import 'package:capstone_sams/global-widgets/datepicker/Datepicker.dart';
import 'package:capstone_sams/global-widgets/text-fields/Textfields.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionTitleWidget.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/ContactPersonModel.dart';
import 'package:capstone_sams/models/MedicalRecordModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/ContactPersonProvider.dart';
import 'package:capstone_sams/providers/MedicalRecordProvider.dart';
import 'package:capstone_sams/providers/PatientProvider.dart';
import 'package:capstone_sams/screens/ehr-list/EhrListScreen.dart';
import 'package:capstone_sams/global-widgets/dropdown/MultiSelect.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class IndividualRecordForm extends StatefulWidget {
  final String? course;

  const IndividualRecordForm({
    super.key,
    this.course,
  });

  @override
  State<IndividualRecordForm> createState() => _IndividualRecordFormState();
}

class _IndividualRecordFormState extends State<IndividualRecordForm> {
  var _isLoading = false;
  bool _isInvalid = false;
  bool _isCheckedEmail = false;
  bool _isCheckedLMP = false;
  bool _isCheckedContactNum = false;
  final _genInfoFormKey = GlobalKey<FormState>();
  final _genInfo = Patient();
  final _medInfoFormKey = GlobalKey<FormState>();
  final _contactInfoFormKey = GlobalKey<FormState>();
  final _contactInfo = ContactPerson();
  TextEditingController otherIllnesses = TextEditingController();
  TextEditingController otherAllergies = TextEditingController();
  TextEditingController otherPastDiseasses = TextEditingController();
  TextEditingController otherFamHistory = TextEditingController();
  TextEditingController lmp = TextEditingController();
  TextEditingController firstAddress = TextEditingController();
  TextEditingController secondAddress = TextEditingController();
  List<String> _selectedAllergy = [];
  List<String> _selectedFamHistory = [];
  List<String> _selectedPastDiseases = [];
  List<String> _selectedIllnesses = [];
  late bool _autoValidate = false;
  DateTime? _birthDate;
  String? _selectedGender;
  late int? getAccountID = 0;
  var _account = Account(isSuperuser: false);
  late String tokena = context.read<AccountProvider>().token!;

  void _onSubmit() async {
    setState(() => _isLoading = true);
    setState(() => _isInvalid = true);
    print('on submit $_isInvalid');
    // Account? getAccount = await context
    //     .read<AccountProvider>()
    //     .fetchAccount(getAccountID, tokena);

    //     Account? patient =
    // await context.read<PatientProvider>().fetchPatient(a, tokena);
    // var a = account!.accountID;
    final isValid1 = _genInfoFormKey.currentState!.validate();
    final isValid2 = _medInfoFormKey.currentState!.validate();
    final isValid3 = _contactInfoFormKey.currentState!.validate();

    if (!isValid1 && !isValid2 && !isValid3) {
      return;
    } else {
      String formattedDate = _birthDate != null
          ? DateFormat('yyyy-MM-dd').format(_birthDate!)
          : 'No date selected';

      final patient = Patient(
        patientID: Uuid().v4(),
        firstName: _genInfo.firstName,
        middleInitial: _genInfo.middleInitial,
        lastName: _genInfo.lastName,
        age: _genInfo.age,
        gender: _selectedGender,
        birthDate: formattedDate,
        course: _genInfo.course,
        yrLevel: _genInfo.yrLevel,
        studNumber: _genInfo.studNumber,
        height: _genInfo.height,
        weight: _genInfo.weight,
        address: firstAddress.text,
        email: _genInfo.email,
        phone: _genInfo.phone,
        assignedPhysician: getAccountID,
      );

      final medicalRecord = MedicalRecord(
        recordNum: Uuid().v4(),
        illnesses: _selectedIllnesses,
        pastDiseases: _selectedPastDiseases,
        allergies: _selectedAllergy,
        familyHistory: _selectedFamHistory,
        lastMensPeriod: lmp.text,
        patient: patient.patientID,
      );

      final contactRecord = ContactPerson(
        contactId: Uuid().v4(),
        fullName: _contactInfo.fullName,
        phone: _contactInfo.phone,
        address: secondAddress.text,
        patient: patient.patientID,
      );

      // _genInfoFormKey.currentState?.save();
      // _medInfoFormKey.currentState?.save();
      // _contactInfoFormKey.currentState?.save();

      final patientRecordProvider =
          Provider.of<PatientProvider>(context, listen: false);
      final medicalRecordProvider =
          Provider.of<MedicalRecordProvider>(context, listen: false);
      final contactRecordProvider =
          Provider.of<ContactPersonProvider>(context, listen: false);
      final token = context.read<AccountProvider>().token!;

      final patientSuccess = await patientRecordProvider.createPatientRecord(
        patient,
        token,
      );
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

      if (patientSuccess && medicalRecordSuccess && contactSuccess) {
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
        const snackBar = SnackBar(
          backgroundColor: Pallete.successColor,
          content: Text(
            '${Strings.successfulAdd} patient.',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        setState(() => _isLoading = false);

        const snackBar = SnackBar(
          backgroundColor: Pallete.dangerColor,
          content: Text(
            '${Strings.dangerAdd} patient.',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // try {
      //   _genInfoFormKey.currentState?.save();
      //   var accountID = context.read<AccountProvider>().id;
      //   final patientRecordProvider = context.read<PatientProvider>();

      //   final success = await patientRecordProvider.createPatientRecord(
      //     // accountID,
      //     patient,
      //     token,
      //   );

      //   if (success) {
      //     int routesCount = 0;
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => EhrListScreen(),
      //       ),
      //       (Route<dynamic> route) {
      //         if (routesCount < 2) {
      //           routesCount++;
      //           return false;
      //         }
      //         return true;
      //       },
      //     );
      //     const snackBar = SnackBar(
      //       backgroundColor: Pallete.successColor,
      //       content: Text(
      //         '${Strings.successfulAdd} patient.',
      //         style: TextStyle(fontWeight: FontWeight.w700),
      //       ),
      //     );
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //   } else {
      //     setState(() {
      //       _isLoading = false;
      //     });

      //     const snackBar = SnackBar(
      //       backgroundColor: Pallete.dangerColor,
      //       content: Text(
      //         '${Strings.dangerAdd} patient.',
      //         style: TextStyle(fontWeight: FontWeight.w700),
      //       ),
      //     );
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //   }
      // } catch (error) {
      //   // Handle unexpected errors
      //   print('Error during patient submission: $error');
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Pallete.dangerColor,
      //       content: Text(
      //         'An unexpected error occurred: $error',
      //         style: TextStyle(fontWeight: FontWeight.w700),
      //       ),
      //     ),
      //   );
      // } finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // }
    }
  }

  List<String> statusList = [
    'Single',
    'Married',
    'Divorced',
    'Separated',
    'Widowed'
  ];

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
      body: ListView(
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
                  'Individual Health Record',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                GenInfoFormSection(),
                MedicalInfoFormSection(),
                ContactInfoFormSection(),
                AssignPhysicianFormSection(),
                SubmitButton(),
              ],
            ),
          ),
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
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizing.borderRadius),
                ),
              ),
              icon: _isLoading
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(4),
                      child: const CircularProgressIndicator(
                        color: Pallete.whiteColor,
                        strokeWidth: 3,
                      ),
                    )
                  : const Icon(
                      Icons.upload,
                      color: Pallete.whiteColor,
                    ),
              label: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Column AssignPhysicianFormSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: Sizing.formSpacing * 2, bottom: Sizing.formSpacing),
          child: Text(
            'Assign Doctor',
            style: TextStyle(
                color: Pallete.mainColor,
                fontSize: Sizing.header4,
                fontWeight: FontWeight.w600),
          ),
        ),
        DropdownSearch<Account>(
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration:
                InputDecoration(labelText: "Select Physician On Duty "),
          ),
          clearButtonProps: ClearButtonProps(isVisible: true),
          popupProps: PopupProps.modalBottomSheet(
            showSearchBox: true,
          ),
          asyncItems: (String filter) async {
            var response = await Dio().get(
              '${Env.prefix}/user/users/physician',
              queryParameters: {"filter": filter},
              options: Options(headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $tokena",
              }),
            );
            // print("Dio Response: $response");
            var models = List<Account>.from(
              response.data.map(
                (json) => Account.fromJson(json),
              ),
            );
            return models;
          },
          itemAsString: (Account account) {
            var string =
                'Dr. ${account.firstName.toString()} ${account.lastName.toString()}';
            return string;
          },
          onChanged: (Account? data) {
            _account.accountRole = data?.accountRole.toString();
            getAccountID = data?.accountID;
          },
        ),
      ],
    );
  }

  Column ContactInfoFormSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: Sizing.formSpacing * 2, bottom: Sizing.formSpacing),
          child: Text(
            'Person to be notified in case of Emergency',
            style: TextStyle(
                color: Pallete.mainColor,
                fontSize: Sizing.header4,
                fontWeight: FontWeight.w600),
          ),
        ),
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
                  validator: 'Enter their full name!',
                  type: TextInputType.name,
                ),
              ),
              SizedBox(height: Sizing.formSpacing),
              Flexible(
                child: FormTextField(
                  onchanged: (value) => _contactInfo.phone = value,
                  labeltext: 'Contact Number*',
                  validator: 'Enter their contact number!',
                  type: TextInputType.phone,
                ),
              ),
              SizedBox(height: Sizing.formSpacing),
              Flexible(
                child: AddressFormField(
                  'Current Address*',
                  secondAddress,
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
                child: const Text('Copy Address Above'),
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
        // SectionTitleWidget(title: 'Medical Information'),
        Form(
          key: _medInfoFormKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
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
              Wrap(
                children: _selectedPastDiseases.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(right: Sizing.spacing),
                    child: Chip(
                      label: Text(e),
                    ),
                  );
                }).toList(),
              ),
              if (_selectedPastDiseases.contains('Other'))
                otherTextField(otherPastDiseasses),
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
              Wrap(
                children: _selectedFamHistory.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(right: Sizing.spacing),
                    child: Chip(
                      label: Text(e),
                    ),
                  );
                }).toList(),
              ),
              if (_selectedFamHistory.contains('Other'))
                otherTextField(otherFamHistory),
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
              Wrap(
                children: _selectedAllergy.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(right: Sizing.spacing),
                    child: Chip(
                      label: Text(e),
                    ),
                  );
                }).toList(),
              ),
              if (_selectedAllergy.contains('Other'))
                otherTextField(otherAllergies),
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
              Wrap(
                children: _selectedIllnesses.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(right: Sizing.spacing),
                    child: Chip(
                      label: Text(e),
                    ),
                  );
                }).toList(),
              ),
              if (_selectedIllnesses.contains('Other'))
                otherTextField(otherIllnesses),
              SizedBox(height: Sizing.formSpacing),
              if (_selectedGender == 'F')
                Flexible(
                  child: FormTextField(
                    onchanged: (value) => lmp = value,
                    labeltext: 'LMP (Last Menstrual Period)',
                    validator: 'Enter their LMP!',
                    type: TextInputType.text,
                  ),
                ),
              if (_selectedGender == 'F')
                Row(
                  children: [
                    Checkbox(
                      value: _isCheckedLMP,
                      onChanged: (value) {
                        setState(() {
                          _isCheckedLMP = value!;
                        });
                      },
                    ),
                    Flexible(
                      child: Text(
                        'Require LMP',
                        overflow: TextOverflow.ellipsis,
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

  Column GenInfoFormSection() {
    print(_isInvalid);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SectionTitleWidget(title: 'General Information'),
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
                      validator: 'Enter their surname!',
                      type: TextInputType.name,
                    ),
                  ),
                  SizedBox(width: Sizing.formSpacing),
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) => _genInfo.firstName = value,
                      labeltext: 'First Name*',
                      validator: 'Enter their first name!',
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
                      validator: 'Enter their middle initial!',
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
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) {
                        _genInfo.age = int.tryParse(value);
                      },
                      labeltext: 'Age*',
                      validator: 'Enter their age!',
                      type: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: Sizing.formSpacing),
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
                          isInvalid: _isInvalid,
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
                          isInvalid: _isInvalid,
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
                          visible: _isInvalid,
                          child: Text(
                            'Select a gender!',
                            style: TextStyle(color: Pallete.dangerColor),
                          ),
                        ),
                        // if (_selectedGender == null) Text('Select a gender'),
                      ],
                    ),
                  ),
                ],
              ),
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
              SizedBox(height: Sizing.formSpacing),
              Flexible(
                child: Datepicker(
                  isInvalid: _isInvalid,
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
                visible: _isInvalid,
                child: Text(
                  'Select a birthdate!',
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
                      validator: 'Enter the student course!',
                      type: TextInputType.text,
                    ),

                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     labelText: 'Course*',
                    //     border: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Pallete.primaryColor,
                    //       ),
                    //     ),
                    //     filled: true,
                    //     fillColor: Pallete.palegrayColor,
                    //   ),
                    //   enabled: false,
                    //   keyboardType: TextInputType.name,
                    //   initialValue: widget.course,
                    // ),
                  ),
                  SizedBox(width: Sizing.formSpacing),
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) {
                        _genInfo.yrLevel = int.tryParse(value);
                      },
                      labeltext: 'Year*',
                      validator: 'Enter the student year!',
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
                  validator: 'Enter their student number I.D.!',
                  type: TextInputType.number,
                ),
              ),
              SizedBox(height: Sizing.formSpacing),
              Flexible(
                child: AddressFormField('Current Address*', firstAddress),
              ),
              SizedBox(height: Sizing.formSpacing),
              Row(
                children: <Widget>[
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) {
                        _genInfo.height = double.tryParse(value);
                      },
                      labeltext: 'Height*',
                      validator: 'Enter their height!',
                      type: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: Sizing.formSpacing),
                  Flexible(
                    child: FormTextField(
                      onchanged: (value) {
                        _genInfo.weight = double.tryParse(value);
                      },
                      labeltext: 'Weight*',
                      validator: 'Enter their weight!',
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
                          validator: 'Enter their email!',
                          type: TextInputType.emailAddress,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isCheckedEmail,
                              onChanged: (value) {
                                setState(() {
                                  _isCheckedEmail = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: Text(
                                'Require email',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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
                          labeltext: 'Contact Number*',
                          validator: 'Enter their contact number!',
                          type: TextInputType.phone,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isCheckedContactNum,
                              onChanged: (value) {
                                setState(() {
                                  _isCheckedContactNum = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: Text(
                                'Require contact number',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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

  TextFormField AddressFormField(
      String labeltext, TextEditingController controller) {
    return TextFormField(
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
      maxLines: 4,
      keyboardType: TextInputType.text,
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
