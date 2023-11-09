import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/screens/authentication/LoginScreen.dart';
import 'package:capstone_sams/screens/home/HomeScreen.dart';
import 'package:capstone_sams/screens/medical_notes/MedicalNotesScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../constants/theme/sizing.dart';
import '../screens/ehr-list/EhrListScreen.dart';
import 'search-bar/SearchPatientDelegate.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
    required this.username,
    required this.profile,
  });
  final String username, profile;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _isLoading = false;

  void _onSubmit() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Are you sure?',
          style: TextStyle(
              color: Pallete.dangerColor, fontWeight: FontWeight.bold),
        ),
        content: const Text('Please confirm if you want to logout'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Pallete.greyColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              setState(() => _isLoading = true);
              var success = await context.read<AccountProvider>().logout();

              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }
            },
            child: Text(
              'Log me out',
              style: TextStyle(
                color: Pallete.dangerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                  backgroundImage: AssetImage(
                      'lib/sams_server/upload-photo${widget.profile}'),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  height: Sizing.padding,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.username),
                  ],
                ),
              ],
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
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.solidAddressCard),
            title: const Text('Health Records'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EhrListScreen(),
                ),
              );
            },
          ),
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
            },
          ),
          SizedBox(
            height: Sizing.padding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Sizing.sectionSymmPadding),
            child: Divider(color: Colors.black),
          ),
          SizedBox(
            height: Sizing.padding,
          ),
          ListTile(
            leading: _isLoading
                ? Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(4),
                    child: const CircularProgressIndicator(
                      color: Pallete.mainColor,
                      strokeWidth: 3,
                    ),
                  )
                : FaIcon(FontAwesomeIcons.rightFromBracket),
            title: const Text('Logout'),
            onTap: _isLoading ? null : _onSubmit,
          ),
        ],
      ),
    );
  }
}
