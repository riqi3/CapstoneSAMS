import 'package:capstone_sams/screens/ehr-list/EHRList.dart';
import 'package:capstone_sams/screens/home/HomeScreen.dart';
import 'package:capstone_sams/screens/patient-record/PatientRecordScreen.dart';
import 'package:capstone_sams/theme/sizing.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'SearchBarSAMS.dart';

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
                  backgroundImage: NetworkImage(profile),
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
            title: const Text('Electronic Health Records'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EHRList(),
                ),
              );
              print('ehr');
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.flask),
            title: const Text('Laboratories'),
            onTap: () {
              print('laboratories');
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.notesMedical),
            title: const Text('Medical Notes'),
            onTap: () {
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
