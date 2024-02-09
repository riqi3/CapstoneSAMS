import 'package:capstone_sams/constants/Dimensions.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionInfoWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardTemplate.dart';
import 'package:capstone_sams/global-widgets/cards/CardTitleWidget.dart';
import 'package:capstone_sams/global-widgets/loading-indicator/CardContentLoading.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionTitleWidget.dart';
import 'package:capstone_sams/global-widgets/texts/RichTextTemplate.dart';
import 'package:capstone_sams/global-widgets/texts/TitleValueText.dart';
import 'package:capstone_sams/models/ContactPersonModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/ContactPersonProvider.dart';
import 'package:capstone_sams/global-widgets/forms/ChangePhysicianForm.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
    ContactPersonProvider contactPersonProvider =
        Provider.of<ContactPersonProvider>(context);
    AccountProvider accountProvider = Provider.of<AccountProvider>(context);

    return CardTemplate(
      column: Column(
        children: [
          CardTitleWidget(title: 'Patient Information'),
          CardSectionTitleWidget(title: 'General Information'),
          CardSectionInfoWidget(widget: GeneralInfoData(context)),
          CardSectionTitleWidget(title: 'Emergency Contact Information'),
          CardSectionInfoWidget(widget: ContactInfoData(contactPersonProvider)),
        ],
      ),
    );
  }

  PopupMenuButton<dynamic> popupActionWidget() {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.pencil,
              color: Pallete.successColor,
            ),
            title: Text(
              'Change Physician',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Pallete.successColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPhysicianScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  LayoutBuilder GeneralInfoData(BuildContext context) {
    final currentDate = DateTime.now();
    DateTime originalDate1 = DateTime.parse(widget.patient.birthDate!);
    final age = calculateAge(currentDate, originalDate1);
    String birthDate = DateFormat('MMM d, y').format(originalDate1);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= Dimensions.mobileWidth) {
          return _genInfoTabletView(birthDate, age, context);
        }
        return _genInfoMobileView(birthDate, age, context);
      },
    );
  }

  Column _genInfoMobileView(
      String birthDate, Map<String, int> age, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichTextTemplate(
          title: '',
          content:
              '${widget.patient.firstName?.toUpperCase()} ${widget.patient.middleInitial?.toUpperCase()}. ${widget.patient.lastName?.toUpperCase()}',
          fontsize: Sizing.header5,
          fontweight: FontWeight.bold,
        ),
        Table(
          columnWidths: <int, TableColumnWidth>{
            0: FixedColumnWidth(Sizing.columnWidth1),
            1: FixedColumnWidth(Sizing.columnWidth3 + 30),
          },
          children: [
            TableRow(
              children: <Widget>[
                RichTextTemplate(
                  title: 'Student No#:',
                  content: '',
                ),
                RichTextTemplate(
                  title: '',
                  content: '${widget.patient.studNumber}',
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TitleValueText(
                  title: 'Course/Year:',
                  value: '',
                ),
                TitleValueText(
                  title: '',
                  value: '${course()}${widget.patient.yrLevel}',
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: Sizing.formSpacing),
                  child: TitleValueText(
                    title: 'Birthdate:',
                    value: '',
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: Sizing.formSpacing),
                  child: TitleValueText(
                    title: '',
                    value: '${birthDate}',
                  ),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TitleValueText(
                  title: 'Age:',
                  value: '',
                ),
                TitleValueText(
                  title: '',
                  value: '${age['years']}y ${age['months']}m ${age['days']}d',
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TitleValueText(
                  title: 'Height:',
                  value: '',
                ),
                TitleValueText(
                  title: '',
                  value: '${widget.patient.height} cm',
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TitleValueText(
                  title: 'Weight:',
                  value: '',
                ),
                TitleValueText(
                  title: '',
                  value: '${widget.patient.weight} kg',
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TitleValueText(
                  title: 'Status:',
                  value: '',
                ),
                TitleValueText(
                  title: '',
                  value: '${widget.patient.patientStatus}',
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                RichTextTemplate(
                  title: 'Email:',
                  content: '',
                ),
                RichTextTemplate(
                  title: '',
                  content: '${widget.patient.email}',
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TitleValueText(
                  title: 'Contact No#:',
                  value: '',
                ),
                TitleValueText(
                  title: '',
                  value: '${widget.patient.phone}',
                ),
              ],
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: RichTextTemplate(
            title: 'Address:             ',
            content: '${widget.patient.address}',
          ),
        ),
      ],
    );
  }

  Column _genInfoTabletView(
      String birthDate, Map<String, int> age, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichTextTemplate(
          title: '',
          content:
              '${widget.patient.firstName?.toUpperCase()} ${widget.patient.middleInitial?.toUpperCase()}. ${widget.patient.lastName?.toUpperCase()}',
          fontsize: Sizing.header5,
          fontweight: FontWeight.bold,
        ),
        Table(
          columnWidths: <int, TableColumnWidth>{
            0: FixedColumnWidth(Sizing.columnWidth4),
            1: FixedColumnWidth(Sizing.columnWidth3),
          },
          children: [
            TableRow(
              children: <Widget>[
                RichTextTemplate(
                  title: 'Student No#: ',
                  content: '${widget.patient.studNumber}',
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
                    value: '${birthDate}',
                  ),
                ),
                TitleValueText(
                  title: 'Age: ',
                  value: '${age['years']}y ${age['months']}m ${age['days']}d',
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
                  title: 'Height (cm): ',
                  value: '${widget.patient.height}',
                ),
                TitleValueText(
                  title: 'Weight (kg): ',
                  value: '${widget.patient.weight}',
                ),
                TitleValueText(
                  title: 'Status: ',
                  value: '${widget.patient.patientStatus}',
                ),
              ],
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
                RichTextTemplate(
                  title: 'Email: ',
                  content: '${widget.patient.email}',
                ),
                TitleValueText(
                  title: 'Contact No#: ',
                  value: '${widget.patient.phone}',
                ),
              ],
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: RichTextTemplate(
            title: 'Address: ',
            content: '${widget.patient.address}',
          ),
        ),
      ],
    );
  }

  FutureBuilder<ContactPerson> ContactInfoData(
      ContactPersonProvider contactPersonProvider) {
    return FutureBuilder<ContactPerson>(
      future: contactPersonProvider.fetchContactPeople(
          token, widget.patient.patientID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CardContentLoading());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final ContactPerson contactPerson = snapshot.data!;

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth >= Dimensions.mobileWidth) {
                return _contactInfoTabletView(contactPerson, context);
              }
              return _contactInfoMobileView(contactPerson, context);
            },
          );
        }
      },
    );
  }

  Column _contactInfoTabletView(
      ContactPerson contactPerson, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichTextTemplate(
          title: '',
          content: '${contactPerson.fullName?.toUpperCase()}',
          fontsize: Sizing.header5,
          fontweight: FontWeight.bold,
        ),
        Table(
          columnWidths: <int, TableColumnWidth>{
            0: FixedColumnWidth(Sizing.columnWidth4),
          },
          children: [
            TableRow(
              children: <Widget>[
                TitleValueText(
                  title: 'Contact No#:',
                  value: '${contactPerson.phone}',
                ),
              ],
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: RichTextTemplate(
            title: 'Address: ',
            content: '${contactPerson.address}',
          ),
        ),
      ],
    );
  }

  Column _contactInfoMobileView(
      ContactPerson contactPerson, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichTextTemplate(
          title: '',
          content: '${contactPerson.fullName?.toUpperCase()}',
          fontsize: Sizing.header5,
          fontweight: FontWeight.bold,
        ),
        Table(
          columnWidths: <int, TableColumnWidth>{
            0: FixedColumnWidth(Sizing.columnWidth1),
            1: FixedColumnWidth(Sizing.columnWidth3 + 30),
          },
          children: [
            TableRow(
              children: <Widget>[
                TitleValueText(
                  title: 'Contact No#:',
                  value: '',
                ),
                TitleValueText(
                  title: '',
                  value: '${contactPerson.phone}',
                ),
              ],
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: RichTextTemplate(
            title: 'Address:             ',
            content: '${contactPerson.address}',
          ),
        ),
      ],
    );
  }
}
