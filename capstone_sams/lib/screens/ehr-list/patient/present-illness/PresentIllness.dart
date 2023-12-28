import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:flutter/material.dart';

class PresentIllnessFormScreen extends StatefulWidget {
  final String? course;
  // final String? status;
  const PresentIllnessFormScreen({
    super.key,
    this.course,
    // this.status,
  });

  @override
  State<PresentIllnessFormScreen> createState() =>
      _PresentIllnessFormScreenState();
}

class _PresentIllnessFormScreenState extends State<PresentIllnessFormScreen> {
  var _isLoading = false;
  // var _statusEnabled = true;
  final _genInfoFormKey = GlobalKey<FormState>();
  final _medInfoFormKey = GlobalKey<FormState>();
  final _emergencyInfoFormKey = GlobalKey<FormState>();
  late bool _autoValidate = false;
  DateTime? _birthDate;
  List<String> statusList = [
    'Single',
    'Married',
    'Divorced',
    'Separated',
    'Widowed'
  ];
  List<String> allergyList = ['N/A', 'Food', 'Medicine', 'Other'];
  List<String> familyHistoryList = ['N/A', 'Diabetes', 'Other'];
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
  late String statustValue = statusList.first;
  late String allergyValue = allergyList.first;
  late String familyValue = familyHistoryList.first;
  late String illnessesValue = illnessesList.first;
  String selectedGender = '';
  void _onSubmit() async {}

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
                Padding(
                  padding: const EdgeInsets.only(
                      top: Sizing.formSpacing * 2, bottom: Sizing.formSpacing),
                  child: Text(
                    'General Information',
                    style: TextStyle(
                        color: Pallete.mainColor,
                        fontSize: Sizing.header4,
                        fontWeight: FontWeight.w600),
                  ),
                ),
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
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Surname*',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          SizedBox(width: Sizing.formSpacing),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Firstname*',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          SizedBox(width: Sizing.formSpacing),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 60.0, // Set the minimum width here
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'M.I.*',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                counterText: '',
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              maxLength: 1,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Age*',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      value: 'male',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value as String;
                                        });
                                      },
                                    ),
                                    Text('Male'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      value: 'female',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value as String;
                                        });
                                      },
                                    ),
                                    Text('Female'),
                                  ],
                                ),
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
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
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
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Birth Date*',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Pallete.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Pallete.palegrayColor,
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime(1980),
                              firstDate: DateTime(1980),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                setState(() {
                                  _birthDate = selectedDate;
                                });
                              }
                            });
                          },
                          controller: TextEditingController(
                            text: _birthDate != null
                                ? _birthDate!.toLocal().toString().split(' ')[0]
                                : '',
                          ),
                        ),
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Course',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              enabled: false,
                              keyboardType: TextInputType.name,
                              initialValue: widget.course,
                            ),
                          ),
                          SizedBox(width: Sizing.formSpacing),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Year*',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Student Number*',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Pallete.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Pallete.palegrayColor,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Current Address*',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Pallete.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Pallete.palegrayColor,
                          ),
                          maxLines: 4,
                          keyboardType: TextInputType.streetAddress,
                        ),
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Height',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: Sizing.formSpacing),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Weight',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Active Email*',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(width: Sizing.formSpacing),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Contact Number*',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                filled: true,
                                fillColor: Pallete.palegrayColor,
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: Sizing.formSpacing * 2, bottom: Sizing.formSpacing),
                  child: Text(
                    'Medical Information',
                    style: TextStyle(
                        color: Pallete.mainColor,
                        fontSize: Sizing.header4,
                        fontWeight: FontWeight.w600),
                  ),
                ),
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
                        'Allergy Type*',
                        style: TextStyle(
                          color: Pallete.greyColor,
                        ),
                      ),
                      Flexible(
                        child: DropdownMenu<String>(
                          hintText: 'Allergy Type*',
                          onSelected: (String? value) {
                            setState(() {
                              allergyValue = value!;
                            });
                          },
                          dropdownMenuEntries: allergyList
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      if (allergyValue == 'Other')
                        Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Other',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Pallete.primaryColor,
                                ),
                              ),
                              filled: true,
                              fillColor: Pallete.palegrayColor,
                            ),
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      SizedBox(height: Sizing.formSpacing),
                      Text(
                        'Family History*',
                        style: TextStyle(
                          color: Pallete.greyColor,
                        ),
                      ),
                      Flexible(
                        child: DropdownMenu<String>(
                          hintText: 'Family History*',
                          onSelected: (String? value) {
                            setState(() {
                              familyValue = value!;
                            });
                          },
                          dropdownMenuEntries: familyHistoryList
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      if (familyValue == 'Other')
                        Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Other',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Pallete.primaryColor,
                                ),
                              ),
                              filled: true,
                              fillColor: Pallete.palegrayColor,
                            ),
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      SizedBox(height: Sizing.formSpacing),
                      Text(
                        'Illnesses*',
                        style: TextStyle(
                          color: Pallete.greyColor,
                        ),
                      ),
                      Flexible(
                        child: DropdownMenu<String>(
                          hintText: 'Illness*',
                          onSelected: (String? value) {
                            setState(() {
                              illnessesValue = value!;
                            });
                          },
                          dropdownMenuEntries: illnessesList
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      if (illnessesValue == 'Other')
                        Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Other',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Pallete.primaryColor,
                                ),
                              ),
                              filled: true,
                              fillColor: Pallete.palegrayColor,
                            ),
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                    ],
                  ),
                ),
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
                  key: _emergencyInfoFormKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Full name*',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Pallete.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Pallete.palegrayColor,
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Contact Number*',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Pallete.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Pallete.palegrayColor,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      SizedBox(height: Sizing.formSpacing),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Current Address*',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Pallete.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Pallete.palegrayColor,
                          ),
                          maxLines: 4,
                          keyboardType: TextInputType.streetAddress,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: Sizing.sectionSymmPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Sizing.borderRadius),
                            ),
                          ),
                          icon: _isLoading
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(4),
                                  child: const CircularProgressIndicator(
                                    color: Pallete.mainColor,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(
                                  Icons.upload,
                                ),
                          label: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
