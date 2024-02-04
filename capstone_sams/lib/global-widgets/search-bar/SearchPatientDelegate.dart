import 'package:capstone_sams/global-widgets/loading-indicator/DiagnosisCardLoading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/pallete.dart';
import '../../constants/theme/sizing.dart';
import '../../models/PatientModel.dart';

import '../../providers/AccountProvider.dart';
import '../../providers/PatientProvider.dart';
import '../../screens/ehr-list/patient/PatientTabsScreen.dart';

class SearchPatientDelegate extends SearchDelegate {
  PatientProvider _patientList = PatientProvider();
  late Future<List<Patient>> patients;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Patient>>(
      future: _patientList.searchPatients(
        query: query,
        token: context.read<AccountProvider>().token!,
        // accountID: context.read<AccountProvider>().acc!.accountID!
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(Sizing.sectionSymmPadding),
            child: ListCardLoading(),
          );
        }
        List<Patient>? patient = snapshot.data;

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: patient?.length,
          itemBuilder: (context, index) {
            final patient1 = snapshot.data![index];
            // final labresult = int.parse(patient1.patientID as String);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientTabsScreen(
                      patient: patient1,
                      // index: labresult
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizing.sectionSymmPadding, vertical: 4),
                child: Card(
                  elevation: Sizing.cardElevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Sizing.borderRadius / 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizing.sectionSymmPadding / 4,
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${patient?[index].firstName}',
                                    style: TextStyle(
                                      fontSize: Sizing.header5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${patient?[index].middleInitial}.',
                                    style: TextStyle(
                                      fontSize: Sizing.header5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${patient?[index].lastName}',
                                    style: TextStyle(
                                      fontSize: Sizing.header5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${patient?[index].studNumber}',
                                style: TextStyle(
                                    fontSize: Sizing.header5,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: FaIcon(FontAwesomeIcons.arrowRight),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search Patient'),
    );
  }

  void setState(Null Function() param0) {}
}
