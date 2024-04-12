import 'package:capstone_sams/constants/theme/pallete.dart'; 
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicalNotesProvider.dart'; 
 

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/theme/sizing.dart';
import 'search-bar/SearchPatientDelegate.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  AccountProvider user;
  Dashboard({
    super.key,
    required this.user,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _isLoading = false;

  void _onSubmit() async {
    setState(() => _isLoading = true);
    var success = await context.read<AccountProvider>().logout();

    if (success) {
      context.read<TodosProvider>().setEmpty();
      Navigator.pushNamedAndRemoveUntil(
          context, "/", (Route<dynamic> route) => false);
    }
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
                  backgroundImage: widget.user.photo == null
                      ? AssetImage('assets/images/admin-profilepic.png')
                      : AssetImage(
                          'lib/sams_server/upload-photo${widget.user.photo}'),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  height: Sizing.padding,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.user.username.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${widget.user.firstName.toString()} '),
                        Text('${widget.user.middleName.toString()} '),
                        Text(widget.user.lastName.toString()),
                      ],
                    ),
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
              // Navigator.pushNamed(context, '/home');
              if (ModalRoute.of(context)!.settings.name != '/home') {
                Navigator.pushNamed(context, '/home');
              }
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.solidClipboard),
            title: const Text('Health Records'),
            onTap: () {
              if (ModalRoute.of(context)!.settings.name != '/ehr_list') {
                Navigator.pushNamed(context, '/ehr_list');
              }
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.notesMedical),
            title: const Text('Medical Notes'),
            onTap: () {
              if (ModalRoute.of(context)!.settings.name != '/med_notes') {
                Navigator.pushNamed(context, '/med_notes');
              }
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
