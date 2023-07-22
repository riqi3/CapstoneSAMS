import 'package:capstone_sams/screens/home/HomeScreen.dart';
import 'package:capstone_sams/screens/lab/LabScreen.dart';
import 'package:capstone_sams/screens/lab/LabTabsScreen.dart';
import 'package:capstone_sams/screens/medical_notes/medical_notes_page.dart';
import 'package:capstone_sams/screens/order-entry/CPOE_analyze_page.dart';

import 'package:capstone_sams/theme/sizing.dart';
import 'package:capstone_sams/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/patient.dart';
import '../screens/ehr-list/EHRListScreen.dart';
import 'search-bar/SearchPatientDelegate.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
    required this.profile,
  });

  final String profile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(profile),
                  // backgroundImage: NetworkImage(profile),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  height: Sizing.padding,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('FULLNAME'),
                    Text(
                      'fullname@gmail.com',
                      style: TextStyle(),
                    ),
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          SizedBox(
            height: Sizing.padding,
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.magnifyingGlass),
            title: const Text('Search A Patient'),
            onTap: () {
              showSearch(
                context: context,
                delegate: SearchPatientDelegate(),
              );
              print('search patient');
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.houseMedical),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
              print('home');
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.solidAddressCard),
            title: const Text('Health Records'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EHRListScreen(),
                ),
              );
              print('ehr');
            },
          ),
          // ListTile(
          //   leading: FaIcon(FontAwesomeIcons.flask),
          //   title: const Text('Laboratories'),
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (context) => LabTabsScreen(patient: ,

          //     //     ),
          //     //   ),
          //     // );
          //     print('laboratories');
          //   },
          // ),
          // ListTile(
          //   leading: FaIcon(FontAwesomeIcons.prescription),
          //   title: const Text('Physician Order Entry'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const CPOEScreen(),
          //       ),
          //     );
          //     print('cpoe');
          //   },
          // ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.notesMedical),
            title: const Text('Medical Notes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicalNotes(),
                ),
              );
              print('med notes');
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.solidUser),
            title: const Text('Profile'),
            onTap: () {
              print('profile');
            },
          ),
          SizedBox(
            height: Sizing.padding,
          ),
          Divider(),
          SizedBox(
            height: Sizing.padding,
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.rightFromBracket),
            title: const Text('Logout'),
            onTap: () {
              print('logout');
            },
          ),
        ],
      ),
    );
  }
}
