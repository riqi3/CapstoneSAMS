import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/bottomsheet/BottomSheetTitle.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionInfoWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardTemplate.dart';
import 'package:capstone_sams/global-widgets/cards/CardTitleWidget.dart';
import 'package:capstone_sams/global-widgets/loading-indicator/DiagnosisCardLoading.dart';
import 'package:capstone_sams/global-widgets/pop-menu-buttons/pop-menu-item/PopMenuItemTemplate.dart';
import 'package:capstone_sams/global-widgets/texts/NoDataTextWidget.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DiagnosisInfoCard extends StatefulWidget {
  final Patient patient;
  DiagnosisInfoCard({
    super.key,
    required this.patient,
  });

  @override
  State<DiagnosisInfoCard> createState() => _DiagnosisInfoCardState();
}

class _DiagnosisInfoCardState extends State<DiagnosisInfoCard> {
  late Stream<List<PresentIllness>> presentIllness;
  late String token = context.read<AccountProvider>().token!;
  Account? account = Account(isSuperuser: false);

  @override
  void initState() {
    super.initState();
    token = context.read<AccountProvider>().token!;
    presentIllness = Stream.fromFuture(context
        .read<PresentIllnessProvider>()
        .fetchComplaints(token, widget.patient.patientID));
  }

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      column: Column(
        children: [
          CardTitleWidget(title: "History of Illnesses"
              // title:
              //     'Dr. ${accountProvider.firstName} ${middleInitial}. ${accountProvider.lastName}'
              ),
          SizedBox(height: Sizing.sectionSymmPadding),
          // CardSectionTitleWidget(title: "Patient's Present Illnesses"),
          CardSectionInfoWidget(
            shader: false,
            widget: PresentIllnessData(),
          ),
        ],
      ),
    );
  }

  StreamBuilder<List<PresentIllness>> PresentIllnessData() {
    return StreamBuilder(
      stream: presentIllness,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: DiagnosisCardLoading());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Container(
              height: 100,
              child: Center(
                child: NoDataTextWidget(
                  text: Strings.noRecordedIllnesses,
                ),
              ),
            ),
          );
        } else {
          final presentIllnessList = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: presentIllnessList.length,
            itemBuilder: (context, index) {
              final illness = presentIllnessList[index];
              final illnessIndex = '${presentIllnessList.length - index}';

              return FutureBuilder<Account?>(
                future: context
                    .read<AccountProvider>()
                    .fetchAccount(illness.created_by, token),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return CircularProgressIndicator();
                    return Center(child: Container());
                  } else if (snapshot.hasError) {
                    return Text('Error loading account details');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('Account details not available');
                  } else {
                    final account = snapshot.data!;

                    AccountProvider accountProvider =
                        Provider.of<AccountProvider>(context);

                    String middleInitial = account.middleName![0];
                    DateTime originalDate = DateTime.parse(illness.created_at!);
                    print('ORIGINAL ${illness.created_at}');
                    String formattedDate =
                        DateFormat('MMMM d, y | HH:mm').format(originalDate);
                    print('FORMAT ${formattedDate}');
                    return Card(
                      color: Colors.white,
                      elevation: Sizing.cardElevation,
                      margin: EdgeInsets.symmetric(
                        vertical: Sizing.sectionSymmPadding / 4,
                      ),
                      child: GestureDetector(
                        onTap: () => viewIllnessMethod(
                            context, illness, illnessIndex, account),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Dx #${illnessIndex}: ',
                              ),
                              Expanded(
                                child: Text(
                                  '${illness.illnessName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              account.accountID == accountProvider.id
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${account.firstName} ${middleInitial}. ${account.lastName}, ${account.suffixTitle}',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Pallete.greyColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      '${account.firstName} ${middleInitial}. ${account.lastName}, ${account.suffixTitle}',
                                      style:
                                          TextStyle(color: Pallete.greyColor),
                                    ),
                              Text(
                                '${formattedDate}',
                                style: TextStyle(color: Pallete.greyColor),
                              ),
                            ],
                          ),
                          trailing: popupActionWidget(
                              illness, illnessIndex, account, accountProvider),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  PopupMenuButton<dynamic> popupActionWidget(PresentIllness illness,
      String illnessIndex, Account account, AccountProvider accountProvider) {
    if (account.accountID != accountProvider.id) {
      return PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: PopMenuItemTemplate(
              icon: FontAwesomeIcons.solidEye,
              color: Pallete.infoColor,
              title: 'View',
              ontap: () {
                viewIllnessMethod(context, illness, illnessIndex, account);
              },
            ),
          )
        ],
      );
    }
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: PopMenuItemTemplate(
            icon: FontAwesomeIcons.solidEye,
            color: Pallete.infoColor,
            title: 'View',
            ontap: () {
              viewIllnessMethod(context, illness, illnessIndex, account);
            },
          ),
        ),
        PopupMenuItem(
          child: PopMenuItemTemplate(
            icon: FontAwesomeIcons.pen,
            color: Pallete.successColor,
            title: 'Edit',
            ontap: () {},
          ),
        ),
        PopupMenuItem(
          child: PopMenuItemTemplate(
            icon: FontAwesomeIcons.trash,
            color: Pallete.dangerColor,
            title: 'Delete',
            ontap: () {},
          ),
        ),
      ],
    );
  }

  void viewIllnessMethod(BuildContext context, PresentIllness illness,
      String illnessIndex, Account account) {
    String middleInitial = account.middleName![0];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * .85,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(Sizing.borderRadius),
            topRight: const Radius.circular(Sizing.borderRadius),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: Sizing.sectionSymmPadding,
              ),
              child: BottomSheetTitle(title: 'Dx #${illnessIndex}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Sizing.sectionSymmPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chief Complaint: ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(
                          '${illness.complaint}',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Findings: ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width / 1,
                        child: Text(
                          '${illness.findings}',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diagnosis: ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width / 1,
                        child: Text(
                          '${illness.diagnosis}',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Treatment: ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width / 1,
                        child: Text(
                          '${illness.treatment}',
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
}
