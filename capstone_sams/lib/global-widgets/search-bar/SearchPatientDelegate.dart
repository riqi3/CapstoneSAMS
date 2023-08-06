import 'package:capstone_sams/theme/pallete.dart';
import 'package:flutter/material.dart';

import '../../models/PatientModel.dart';

import '../../providers/PatientProvider.dart';
import '../../screens/ehr-list/patient/health-record/PatientTabsScreen.dart';
import '../../theme/sizing.dart';

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
      future: _patientList.searchPatients(query: query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Patient>? patient = snapshot.data;

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: patient?.length,
          itemBuilder: (context, index) {
            final patient1 = snapshot.data![index];
            return GestureDetector(
              onTap: () {
                // print(patient.firstName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientTabsScreen(
                        patient: patient1, index: index.toString()),
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
                      vertical: Sizing.sectionSymmPadding / 2,
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Pallete.mainColor,
                              borderRadius: BorderRadius.circular(
                                  Sizing.borderRadius / 2),
                            ),
                            child: Center(
                              child: Text(
                                '${patient?[index].patientId}',
                                style: TextStyle(
                                    fontSize: Sizing.header4,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
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
                                    '${patient?[index].middleName}',
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
                                '${patient?[index].birthDate}',
                                style: TextStyle(
                                    fontSize: Sizing.header5,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  // @override
  // Widget buildResults(BuildContext context) {
  //   List<String> matchQuery = [];
  //   for (var searchPatient in searchTerms) {
  //     if (searchPatient.toLowerCase().contains(query.toLowerCase())) {
  //       matchQuery.add(searchPatient);
  //     }
  //   }
  //   return ListView.builder(
  //     itemCount: matchQuery.length,
  //     itemBuilder: (context, index) {
  //       var result = matchQuery[index];
  //       return ListTile(
  //         title: Text(result),
  //       );
  //     },
  //   );
  // }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   List<String> matchQuery = [];

  //   for (var fruit in _patientList) {
  //     if (fruit.toLowerCase().contains(query.toLowerCase())) {
  //       matchQuery.add(fruit);
  //     }
  //   }
  //   return ListView.builder(
  //     itemCount: matchQuery.length,
  //     itemBuilder: (context, index) {
  //       var result = matchQuery[index];
  //       return ListTile(
  //         title: Text(result),
  //       );
  //     },
  //   );
  // }
}
