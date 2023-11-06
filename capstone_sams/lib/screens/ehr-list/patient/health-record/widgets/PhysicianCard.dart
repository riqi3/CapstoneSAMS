import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/MedicineModel.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/providers/PrescriptionProvider.dart';
import 'package:capstone_sams/screens/ehr-list/patient/health-record/widgets/Info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PhysicianCard extends StatefulWidget {
  final Patient patient;
  const PhysicianCard({
    Key? key,
    required this.patient,
  }) : super(key: key);

  @override
  State<PhysicianCard> createState() => _PhysicianCardState();
}

class _PhysicianCardState extends State<PhysicianCard> {
  late Future<List<Account>> physicians;
  late Medicine medicine = Medicine();

  @override
  void initState() {
    super.initState();
    physicians = fetchPhysicians();
  }

  Future<List<Account>> fetchPhysicians() async {
    try {
      final provider =
          Provider.of<PrescriptionProvider>(context, listen: false);
      await provider.fetchPrescriptions(widget.patient.patientId);
      return provider.physicians;
    } catch (error, stackTrace) {
      print("Error fetching data: $error");
      print(stackTrace);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print(physicians);
    return Container(
      height: 200,
      child: FutureBuilder<List<Account>>(
        future: physicians,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No prescriptions were written for this patient.',
                maxLines: 2,
                style: TextStyle(color: Pallete.greyColor),
              ),
            );
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.hasError}');
            print(physicians);
            return Text('Error: ${snapshot.hasError}');
          } else {
            final physicianList = snapshot.data;

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: physicianList!.length,
              itemBuilder: (context, index) {
                final physician = physicianList[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      press(context, widget.patient, physician);
                    },
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(
                            'ID# ${physician.accountID}',
                            style: TextStyle(
                              color: Pallete.mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' | ${physician.firstName} ${physician.lastName}',
                          ),
                        ],
                      ),
                      trailing: FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Pallete.mainColor,
                        size: Sizing.sectionIconSize,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<dynamic> press(
      BuildContext context, Patient patient, Account physician) {
    return showModalBottomSheet(
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
              child: Container(
                decoration: BoxDecoration(
                  color: Pallete.mainColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Sizing.borderRadius),
                      topLeft: Radius.circular(Sizing.borderRadius)),
                ),
                alignment: Alignment.centerLeft,
                padding:
                    EdgeInsets.symmetric(horizontal: Sizing.sectionSymmPadding),
                width: MediaQuery.of(context).size.width,
                height: Sizing.cardContainerHeight,
                child: Text(
                  'Order of ${physician.firstName}',
                  style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: Sizing.header3,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Info(
              patient: patient,
              medicine: medicine,
              physician: physician,
              index: physician.accountID.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
