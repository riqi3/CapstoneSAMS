import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/bottomsheet/BottomSheetTitle.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionInfoWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardTemplate.dart';
import 'package:capstone_sams/global-widgets/cards/CardTitleWidget.dart';
import 'package:capstone_sams/global-widgets/dialogs/AlertDialogTemplate.dart';
import 'package:capstone_sams/global-widgets/loading-indicator/DiagnosisCardLoading.dart';
import 'package:capstone_sams/global-widgets/pop-menu-buttons/pop-menu-item/PopMenuItemTemplate.dart';
import 'package:capstone_sams/global-widgets/snackbars/Snackbars.dart';
import 'package:capstone_sams/global-widgets/texts/NoDataTextWidget.dart';
import 'package:capstone_sams/global-widgets/texts/RichTextTemplate.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:capstone_sams/models/PresentIllness.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/providers/PresentIllnessProvider.dart';
import 'package:capstone_sams/global-widgets/forms/present-illness/EditPresentIllnessForm.dart';
import 'package:capstone_sams/screens/ehr-list/patient/PatientTabsScreen.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/PhysicianCard.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/crud/medicine/Info.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/crud/medicine/MedicationOrderSection.dart';
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
  late Future<List<Prescription>> prescriptions;
  // late Future<List<Account>> physicians;
  late String token = context.read<AccountProvider>().token!;
  Account? account = Account(isSuperuser: false);
  var removeComplaint = dangerSnackbar('${Strings.remove} diagnosis.');

  @override
  void initState() {
    super.initState();
    token = context.read<AccountProvider>().token!;
    presentIllness = Stream.fromFuture(context
        .read<PresentIllnessProvider>()
        .fetchComplaints(token, widget.patient.patientID));
    final provider = Provider.of<PrescriptionProvider>(context, listen: false);
    prescriptions =
        provider.fetchPrescriptions(widget.patient.patientID, token);
  }

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      column: Column(
        children: [
          CardTitleWidget(title: "History of Illnesses"),
          SizedBox(height: Sizing.sectionSymmPadding),
          CardSectionInfoWidget(widget: PresentIllnessData()),
        ],
      ),
    );
  }

  StreamBuilder<List<PresentIllness>> PresentIllnessData() {
    return StreamBuilder(
      stream: presentIllness,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: ListCardLoading());
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
                    String createdAt = dateFormatter(illness);

                    return Visibility(
                      visible: illness.isDeleted == true ? false : true,
                      child: Card(
                        color: Colors.white,
                        elevation: Sizing.cardElevation,
                        margin: EdgeInsets.symmetric(
                          vertical: Sizing.sectionSymmPadding / 4,
                        ),
                        child: GestureDetector(
                          onTap: () => viewIllnessMethod(
                            context,
                            illness,
                            illnessIndex,
                            account,
                            accountProvider,
                          ),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${createdAt}',
                                  style: TextStyle(
                                    color: Pallete.greyColor,
                                    fontSize: Sizing.header6,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Dx #${illnessIndex}: ',
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${illness.illnessName?.toUpperCase()}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
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
                                              '${account.firstName} ${middleInitial}. ${account.lastName}',
                                              // ${account.suffixTitle}
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Pallete.greyColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '${account.firstName} ${middleInitial}. ${account.lastName}',
                                        // , ${account.suffixTitle}

                                        style:
                                            TextStyle(color: Pallete.greyColor),
                                      ),
                                Text(
                                  'University Physician',
                                  style: TextStyle(
                                    color: Pallete.greyColor,
                                  ),
                                ),
                                // Visibility(
                                //   visible: updatedOn == 'January 6, 2000 | 03:00'
                                //       ? false
                                //       : true,
                                //   child: Text(
                                //     'Edited: ${updatedOn}',
                                //     style: TextStyle(color: Pallete.greyColor),
                                //   ),
                                // ),
                              ],
                            ),
                            trailing: account.accountID != accountProvider.id
                                ? Icon(
                                    Icons.abc,
                                    color: Colors.transparent,
                                  )
                                : popupActionWidget(
                                    illness,
                                    illnessIndex,
                                    account,
                                    accountProvider,
                                    Pallete.greyColor),
                          ),
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

  String dateFormatter(PresentIllness illness) {
    DateTime originalDate1 = DateTime.parse(illness.created_at!);
    String createdAt = DateFormat('MMM d, y | HH:mm').format(originalDate1);
    return createdAt;
  }

  PopupMenuButton<dynamic> popupActionWidget(
      PresentIllness illness,
      String illnessIndex,
      Account account,
      AccountProvider accountProvider,
      Color? color) {
    return PopupMenuButton(
      iconColor: color,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: PopMenuItemTemplate(
            icon: FontAwesomeIcons.pen,
            color: Pallete.successColor,
            size: Sizing.iconAppBarSize,
            title: 'Edit',
            ontap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditPresentMedHistoryForm(
                    presentIllness: illness,
                    patient: widget.patient,
                  ),
                ),
              );
            },
          ),
        ),
        PopupMenuItem(
          child: PopMenuItemTemplate(
            icon: FontAwesomeIcons.trash,
            color: Pallete.dangerColor,
            size: Sizing.iconAppBarSize,
            title: 'Delete',
            ontap: () {
              late String token = context.read<AccountProvider>().token!;
              final provider =
                  Provider.of<PresentIllnessProvider>(context, listen: false);

              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDiaglogTemplate(
                  title: 'Are you sure?',
                  content:
                      "Deleting a patient's illness history record is irreversable and cannot be undone.",
                  buttonTitle: 'Remove diagnosis',
                  onpressed: () => removeComplaintMethod(
                      provider, illness, accountProvider, token, context),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void removeComplaintMethod(
      PresentIllnessProvider provider,
      PresentIllness illness,
      AccountProvider accountProvider,
      String token,
      BuildContext context) {
    provider.removeComplaint(
      illness,
      widget.patient.patientID,
      accountProvider.id,
      token,
    );
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
        if (routesCount < 2) {
          routesCount++;
          return false;
        }
        return true;
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(removeComplaint);
  }

  void viewIllnessMethod(BuildContext context, PresentIllness illness,
      String illnessIndex, Account account, AccountProvider accountProvider) {
    String middleInitial = account.middleName![0];
    String createdAt = dateFormatter(illness);

    final prescriptionProvider =
        Provider.of<PrescriptionProvider>(context, listen: false);

    prescriptionProvider.fetchPrescriptions(widget.patient.patientID, token);

    // print('diagnosis info card ${prescriptionProvider}');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: .85,
        minChildSize: .2,
        maxChildSize: 1,
        shouldCloseOnMinExtent: true,
        snap: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Pallete.whiteColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Sizing.borderRadius),
                  topLeft: Radius.circular(Sizing.borderRadius)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: Sizing.sectionSymmPadding,
                    ),
                    child: BottomSheetTitle(
                      owner: account.accountID != accountProvider.id
                          ? false
                          : true,
                      title: 'Dx #${illnessIndex}',
                      popup: popupActionWidget(illness, illnessIndex, account,
                          accountProvider, Pallete.lightGreyColor2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Sizing.sectionSymmPadding,
                      right: Sizing.sectionSymmPadding,
                      bottom: Sizing.sectionSymmPadding * 4,
                    ),
                    child: Column(
                      children: <Widget>[
                        Card(
                          color: const Color.fromARGB(255, 253, 253, 253),
                          elevation: Sizing.cardElevation,
                          child: Padding(
                            padding:
                                const EdgeInsets.all(Sizing.sectionSymmPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${createdAt}',
                                  style: TextStyle(color: Pallete.greyColor),
                                ),
                                SizedBox(height: Sizing.formSpacing / 2),
                                Text(
                                  '${illness.illnessName!.toUpperCase()}',
                                  style: TextStyle(
                                    fontSize: Sizing.header4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: Sizing.formSpacing / 2),
                                account.accountID == accountProvider.id
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${account.firstName} ${middleInitial}. ${account.lastName}',
                                              //  ${account.suffixTitle}
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Pallete.greyColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '${account.firstName} ${middleInitial}. ${account.lastName}',
                                        // ${account.suffixTitle}
                                        style:
                                            TextStyle(color: Pallete.greyColor),
                                      ),
                                Text(
                                  'University Physician',
                                  style: TextStyle(color: Pallete.greyColor),
                                ),
                                SizedBox(height: Sizing.formSpacing * 2),
                                RichTextTemplate(
                                  title: 'Chief Complaint: ',
                                  content: '${illness.complaint}',
                                ),
                                SizedBox(height: Sizing.formSpacing),
                                RichTextTemplate(
                                  title: 'Findings: ',
                                  content: '${illness.findings}',
                                ),
                                SizedBox(height: Sizing.formSpacing),
                                RichTextTemplate(
                                  title: 'Diagnosis: ',
                                  content: '${illness.diagnosis}',
                                ),
                                SizedBox(height: Sizing.formSpacing),
                                RichTextTemplate(
                                  title: 'Treatment: ',
                                  content: '${illness.treatment}',
                                ),
                                SizedBox(height: Sizing.formSpacing),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  child: FutureBuilder<List<Prescription>>(
                                    future: prescriptions,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        final prescriptions = snapshot.data!;
                                        return ListView.builder(
                                          itemCount: prescriptions.length,
                                          itemBuilder: (context, index) {
                                            final prescription =
                                                prescriptions[index];
                                            if (prescription.illnessID ==
                                                illness.illnessID) {
                                              return ListTile(
                                                title: Text(
                                                    'Prescription ${prescription.presNum}'),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children:
                                                      prescription.medicines!
                                                          .map(
                                                            (medicine) => Text(
                                                              '${medicine.quantity} x ${medicine.drugName}: ${medicine.instructions}',
                                                            ),
                                                          )
                                                          .toList(),
                                                ),
                                              ); // Skip rendering if illnessID doesn't match
                                            }
                                            // Render ListTile only for prescriptions matching the illnessID
                                            return SizedBox.shrink();
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
