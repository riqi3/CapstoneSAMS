import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionInfoWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardTitleWidget.dart';
import 'package:capstone_sams/global-widgets/separators/DividerWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionTitleWidget.dart';
import 'package:capstone_sams/global-widgets/texts/TitleValueText.dart';
import 'package:capstone_sams/models/ContactPersonModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/ContactPersonProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/theme/pallete.dart';
import '../../../../../constants/theme/sizing.dart';
import '../../../../../models/PatientModel.dart';

class PatientInfoCard extends StatefulWidget {
  final Patient patient;
  const PatientInfoCard({super.key, required this.patient});

  @override
  State<PatientInfoCard> createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  late Stream<List<ContactPerson>> contactPerson;
  late String token = context.read<AccountProvider>().token!;

  @override
  void initState() {
    super.initState();
    token = context.read<AccountProvider>().token!;
  }

  String course() {
    String course = '';
    if (widget.patient.course == 'Nursery') {
      course = 'Nursery';
    }

    if (widget.patient.course == 'Kindergarten') {
      course = 'Kindergarten';
    }

    if (widget.patient.course == 'Elementary' ||
        widget.patient.course == 'Junior High School' ||
        widget.patient.course == 'Senior High School') {
      course = 'Grade';
    }

    if (widget.patient.course == 'Tertiary') {
      course = '${widget.patient.course}';
    }

    if (widget.patient.course == 'Law School') {
      course = '${widget.patient.course}';
    }

    return course;
  }

  @override
  Widget build(BuildContext context) {
    ContactPersonProvider contactPersonProvider =
        Provider.of<ContactPersonProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: Sizing.sectionSymmPadding),
      child: Material(
        elevation: Sizing.cardElevation,
        borderRadius: BorderRadius.all(
          Radius.circular(Sizing.borderRadius),
        ),
        child: Column(
          children: [
            CardTitleWidget(title: 'Patient Information'),
            CardSectionTitleWidget(title: 'General Information'),
            CardSectionInfoWidget(widget: GeneralInfoData(context)),
            CardSectionTitleWidget(title: 'Emergency Contact Information'),
            CardSectionInfoWidget(
                widget: ContactInfoData(contactPersonProvider)),
          ],
        ),
      ),
    );
  }

  FutureBuilder<ContactPerson> ContactInfoData(
      ContactPersonProvider contactPersonProvider) {
    return FutureBuilder<ContactPerson>(
      future: contactPersonProvider.fetchContactPeople(
          token, widget.patient.patientID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final ContactPerson contactPerson = snapshot.data!;
          print('address ${contactPerson.address}');

          return ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Colors.black, Colors.transparent],
                stops: [0.95, 1],
              ).createShader(bounds);
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        '${contactPerson.fullName}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Sizing.header5,
                        ),
                      ),
                    ],
                  ),
                  Table(
                    columnWidths: <int, TableColumnWidth>{
                      0: FixedColumnWidth(Sizing.columnWidth4),
                    },
                    children: [
                      TableRow(
                        children: <Widget>[
                          TitleValueText(
                            title: 'Contact No#: ',
                            value: '${contactPerson.phone}',
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1,
                            child: Text(
                              '${contactPerson.address}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  SingleChildScrollView GeneralInfoData(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                '${widget.patient.firstName} ${widget.patient.middleInitial}. ${widget.patient.lastName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Sizing.header5,
                ),
              ),
            ],
          ),
          Table(
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(Sizing.columnWidth4),
              1: FixedColumnWidth(Sizing.columnWidth3),
            },
            children: [
              TableRow(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: Sizing.formSpacing),
                    child: TitleValueText(
                      title: 'Student No#: ',
                      value: '${widget.patient.studNumber}',
                    ),
                  ),
                  TitleValueText(
                    title: 'Course/Year: ',
                    value: '${course()} ${widget.patient.yrLevel}',
                  ),
                ],
              ),
            ],
          ),
          Table(
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(Sizing.columnWidth4),
              1: FixedColumnWidth(Sizing.columnWidth2),
              2: FixedColumnWidth(Sizing.columnWidth2),
            },
            children: [
              TableRow(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: Sizing.formSpacing),
                    child: TitleValueText(
                      title: 'Birthdate: ',
                      value: '${widget.patient.birthDate}',
                    ),
                  ),
                  TitleValueText(
                    title: 'Age: ',
                    value: '${widget.patient.age}',
                  ),
                  TitleValueText(
                    title: 'Sex: ',
                    value: '${widget.patient.gender}',
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TitleValueText(
                    title: 'Height: ',
                    value: '${widget.patient.height}',
                  ),
                  TitleValueText(
                    title: 'Weight: ',
                    value: '${widget.patient.weight}',
                  ),
                  TitleValueText(
                    title: 'Status: ',
                    value: 'UPDATE',
                  ),
                ],
              ),
            ],
          ),
          Table(
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(Sizing.columnWidth4),
              1: FixedColumnWidth(Sizing.columnWidth5),
            },
            children: [
              TableRow(
                children: <Widget>[
                  TitleValueText(
                    title: 'Contact No#: ',
                    value: '${widget.patient.phone}',
                  ),
                  Container(
                    padding: EdgeInsets.only(right: Sizing.formSpacing),
                    child: TitleValueText(
                      title: 'Email: ',
                      value: '${widget.patient.email}',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1,
                    child: Text(
                      '${widget.patient.address}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
