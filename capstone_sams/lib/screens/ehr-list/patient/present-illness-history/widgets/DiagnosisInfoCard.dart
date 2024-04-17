import 'dart:math';

import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/bottomsheet/BottomSheetTitle.dart';
import 'package:capstone_sams/global-widgets/buttons/IconButton.dart';
import 'package:capstone_sams/global-widgets/buttons/IllnessesPagination.dart';
import 'package:capstone_sams/global-widgets/cards/CardSectionInfoWidget.dart';
import 'package:capstone_sams/global-widgets/cards/CardTemplate.dart';
import 'package:capstone_sams/global-widgets/cards/CardTitleWidget.dart';
import 'package:capstone_sams/global-widgets/dialogs/AlertDialogTemplate.dart';
import 'package:capstone_sams/global-widgets/forms/PatientRegistrationForm.dart';
import 'package:capstone_sams/global-widgets/forms/present-illness/PresentIllnessForm.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DiagnosisInfoCard extends StatefulWidget {
  // ScrollController controller;
  final Patient patient;
  bool isReversed;
  DiagnosisInfoCard({
    super.key,
    required this.patient,
    required this.isReversed,
    // required this.controller,
  });

  @override
  State<DiagnosisInfoCard> createState() => _DiagnosisInfoCardState();
}

class _DiagnosisInfoCardState extends State<DiagnosisInfoCard> {
  late Stream<List<PresentIllness>> presentIllness;
  late Future<List<Prescription>> prescriptions;
  late String token = context.read<AccountProvider>().token!;
  var removeComplaint = dangerSnackbar('${Strings.remove} diagnosis.');

  Account? account = Account(isSuperuser: false);
  Map<PresentIllness, int> diagnosisIndexMap = {};
  List<PresentIllness> filteredIllnessList = [];

  String searchQuery = '';
  int currentPageIndex = 0;
  int pageRounded = 0;
  double? totalPatients = 0;
  double pages1 = 0;

  final double items = 3;

  final start = 0;

  String capitalizeWords(String input) {
    List<String> words = input.split(' ');

    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word.substring(0, 1).toUpperCase() +
          word.substring(1).toLowerCase();
    }).toList();

    return capitalizedWords.join(' ');
  }

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
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: Sizing.sectionSymmPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: SearchBar()),
                SizedBox(width: Sizing.spacing),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ChevronPrev(),
                      SizedBox(width: Sizing.spacing),
                      ChevronNext(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Sizing.sectionSymmPadding),
          CardSectionInfoWidget(widget: PresentIllnessData()),
          // Container(
          //   height: 350,
          //   child: CardSectionInfoWidget(widget: PresentIllnessData()),
          // ),
          SizedBox(height: Sizing.sectionSymmPadding / 2),
        ],
      ),
    );
  }

  Container SearchBar() {
    return Container(
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value.trim();
          });
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          filled: true,
          fillColor: Pallete.lightGreyColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizing.borderRadius * 2),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Pallete.greyColor),
          hintText: '${Strings.search}',
          prefixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: Pallete.greyColor,
                size: Sizing.iconAppBarSize,
              )
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<PresentIllness>> PresentIllnessData() {
    AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    return StreamBuilder(
      stream: presentIllness,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: ListCardLoading());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(Sizing.sectionSymmPadding),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: Center(
                        child: NoDataTextWidget(
                          text: Strings.noRecordedIllnesses,
                        ),
                      ),
                    ),
                    SizedBox(height: Sizing.sectionSymmPadding),
                    IconTextButtons(
                      onpressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PresentIllnessForm(
                              patient: widget.patient,
                            ),
                          ),
                        );
                      },
                      label: 'Diagnose Patient',
                      icon: FaIcon(
                        FontAwesomeIcons.stethoscope,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );

          // Center(
          //   child: Container(
          //     height: 100,
          //     child: Center(
          //       child: NoDataTextWidget(
          //         text: Strings.noRecordedIllnesses,
          //       ),
          //     ),
          //   ),
          // );
        } else {
          var presentIllnessList = snapshot.data!;

          for (int i = presentIllnessList.length - 1; i >= 0; i--) {
            final originalIndex = presentIllnessList.length - i;
            diagnosisIndexMap[presentIllnessList[i]] = originalIndex;
          }

          filteredIllnessList = searchQuery.isEmpty
              ? presentIllnessList.toList()
              : presentIllnessList.where((illness) {
                  return illness.illnessName!
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                }).toList();

          if (searchQuery.isNotEmpty) {
            currentPageIndex = 0;
          }

          filteredIllnessList.sort((a, b) {
            if (widget.isReversed) {
              return DateTime.parse(a.created_at!)
                  .compareTo(DateTime.parse(b.created_at!));
            } else {
              return DateTime.parse(b.created_at!)
                  .compareTo(DateTime.parse(a.created_at!));
            }
          });

          final start = currentPageIndex * items.toInt();
          final end = min(
              (currentPageIndex.toInt() * items.toInt()) + items.toInt(),
              filteredIllnessList.length);
          // final end = min((start * items.toInt()) + items.toInt(),
          //     filteredIllnessList.length);

          filteredIllnessList = filteredIllnessList.sublist(start, end);
          totalPatients = snapshot.data?.length.toDouble();
          pages1 = (totalPatients! / items);

          if (pages1 > items) pages1++;
          pageRounded = pages1.ceil();

          if (filteredIllnessList.isEmpty) {
            return Center(
              child: Container(
                height: 100,
                child: Center(
                  child: NoDataTextWidget(
                    text: 'No matching illnesses found.',
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: filteredIllnessList.length,
            itemBuilder: (context, index) {
              final int displayedIndex;
              if (widget.isReversed) {
                displayedIndex = filteredIllnessList.length - index;
              } else {
                displayedIndex = index + 1;
              }

              final illness = filteredIllnessList[index];
              final originalIndex = diagnosisIndexMap[illness];

              final illnessIndex = '${originalIndex}';

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

                    String middleInitial = account.middleName![0];
                    String createdAt = dateFormatter(illness);
                    String fullName =
                        '${capitalizeWords(account.firstName.toString())} ${capitalizeWords(middleInitial)}. ${capitalizeWords(account.lastName.toString())}';

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
                                              '${fullName}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Pallete.greyColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '${fullName}',
                                        // , ${account.suffixTitle}

                                        style:
                                            TextStyle(color: Pallete.greyColor),
                                      ),
                                Text(
                                  'University ${capitalizeWords(account.accountRole.toString())}',
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

  SizedBox ChevronPrev() {
    return SizedBox(
      height: 40,
      width: 40,
      child: TextButton(
        child: FaIcon(
          FontAwesomeIcons.chevronLeft,
          color: currentPageIndex == 0 ? Pallete.lightGreyColor : Colors.grey,
        ),
        onPressed: () {
          currentPageIndex > 0
              ? setState(() {
                  currentPageIndex -= 1;
                })
              : null;
        },
      ),
    );
  }

  SizedBox ChevronNext() {
    return SizedBox(
      height: 40,
      width: 40,
      child: TextButton(
        onPressed: () {
          currentPageIndex < pageRounded - 1
              ? setState(() {
                  currentPageIndex += 1;
                })
              : null;
        },
        child: FaIcon(
          FontAwesomeIcons.chevronRight,
          color: currentPageIndex == pageRounded - 1
              ? Pallete.lightGreyColor
              : Colors.grey,
        ),
      ),
    );
  }

  String dateFormatter(PresentIllness illness) {
    DateTime originalDate1 = DateTime.parse(illness.created_at!);
    String createdAt = DateFormat('MMM d, y | HH:mm:ss').format(originalDate1);
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
                    onpressed: () {
                      removeComplaintMethod(
                        provider,
                        illness,
                        accountProvider,
                        token,
                        context,
                      );
                      setState(() {});
                    }),
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
        if (routesCount < 3) {
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

    String fullName =
        '${capitalizeWords(account.firstName.toString())} ${capitalizeWords(middleInitial)}. ${capitalizeWords(account.lastName.toString())}';

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
                                              '${fullName}',
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
                                        '${fullName}',
                                        // ${account.suffixTitle}
                                        style:
                                            TextStyle(color: Pallete.greyColor),
                                      ),
                                Text(
                                  'University ${capitalizeWords(account.accountRole.toString())}',
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
                                FutureBuilder<List<Prescription>>(
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
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: prescriptions.length,
                                        itemBuilder: (context, index) {
                                          final prescription =
                                              prescriptions[index];
                                          // prescription.illnessID ==
                                          //   illness.illnessID
                                          if (prescription.illnessID ==
                                                  illness.illnessID &&
                                              prescription
                                                  .medicines!.isNotEmpty) {
                                            return ListTile(
                                              tileColor: Pallete.lightGreyColor,
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: prescription
                                                    .medicines!
                                                    .map(
                                                      (medicine) => Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${medicine.drugCode}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: Sizing
                                                                      .header6,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: Sizing
                                                                      .spacing),
                                                              Expanded(
                                                                  child:
                                                                      Divider(
                                                                color: Pallete
                                                                    .greyColor,
                                                                thickness: 1,
                                                              )),
                                                            ],
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      '${medicine.quantity} x ${medicine.drugName}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Pallete
                                                                            .mainColor,
                                                                        fontSize:
                                                                            Sizing.header6,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: Sizing
                                                                      .sectionSymmPadding),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${medicine.instructions}',
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
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
