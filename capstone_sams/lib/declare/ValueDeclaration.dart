import 'package:capstone_sams/global-widgets/Dashboard.dart';
import 'package:capstone_sams/global-widgets/SearchAppBar.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/screens/home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../constants/theme/pallete.dart';
import '../constants/theme/sizing.dart';
import '../global-widgets/TitleAppBar.dart';

import '../global-widgets/HomeAppBar.dart';

class ValueDashboard extends StatelessWidget {
  const ValueDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AccountProvider>().username;
    var filename = context.watch<AccountProvider>().photo;

    return Dashboard(
      username: '$username',
      profile: '$filename',
    );
  }
}

class ValueHomeAppBar extends StatelessWidget {
  const ValueHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final filename = context.watch<AccountProvider>().photo;

    return HomeAppBar(
      profile: '$filename',
    );
  }
}

class ValuePatientRecord extends StatelessWidget {
  const ValuePatientRecord({super.key, required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SearchAppBar(
      iconColorLeading: Pallete.whiteColor,
      iconColorTrailing: Pallete.whiteColor,
      backgroundColor: Pallete.mainColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BottomPatientTabs(tabController: tabController),
      ),
    );
  }
}

class BottomPatientTabs extends StatelessWidget {
  const BottomPatientTabs({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    // final accountProvider = Provider.of<AccountProvider>(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: Container(
        color: Pallete.mainColor,
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          labelPadding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          indicatorWeight: 2.0,
          indicatorColor: Pallete.whiteColor,
          labelColor: Pallete.whiteColor,
          unselectedLabelColor: Pallete.deselected,
          tabs: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 10,
              child: Tab(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: FaIcon(
                        FontAwesomeIcons.clipboardUser,
                      ),
                    ),
                    Text(
                      'Patient Info',
                      style: TextStyle(fontSize: Sizing.header6),
                    ),
                  ],
                ),
              ),
            ),
            // if (accountProvider.role == 'physician')
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 10,
              child: Tab(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: FaIcon(
                        FontAwesomeIcons.solidClipboard,
                      ),
                    ),
                    Text(
                      'Past Medical History',
                      style: TextStyle(fontSize: Sizing.header6),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 10,
              child: Tab(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: FaIcon(
                        FontAwesomeIcons.headSideCough,
                      ),
                    ),
                    Text(
                      'Present Illness History',
                      style: TextStyle(fontSize: Sizing.header6),
                    ),
                  ],
                ),
              ),
            ),

            // SizedBox(
            //   width: MediaQuery.of(context).size.width / 2 - 10,
            //   child: Tab(
            //     child: Column(
            //       children: [
            //         Align(
            //           alignment: Alignment.center,
            //           child: FaIcon(
            //             FontAwesomeIcons.commentMedical,
            //           ),
            //         ),
            //         Text(
            //           'Diagnosis',
            //           style: TextStyle(fontSize: Sizing.header6),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width / 2 - 10,
            //   child: Tab(
            //     child: Column(
            //       children: [
            //         Align(
            //           alignment: Alignment.center,
            //           child: FaIcon(
            //             FontAwesomeIcons.pills,
            //           ),
            //         ),
            //         Text(
            //           'Treatment',
            //           style: TextStyle(fontSize: Sizing.header6),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ValueMedNotes extends StatelessWidget {
  const ValueMedNotes({super.key, required this.tabController});
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return TitleAppBar(
      onpressed: () => context.go('/home'),
      text: 'Your Notes',
      backgroundColor: Pallete.whiteColor,
      iconColorLeading: Pallete.greyColor,
      iconColorTrailing: Pallete.greyColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BottomMedNotes(tabController: tabController),
      ),
    );
  }
}

class BottomMedNotes extends StatelessWidget {
  const BottomMedNotes({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: Container(
        color: Pallete.whiteColor,
        child: TabBar(
          controller: tabController,
          labelPadding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          indicatorWeight: 2.0,
          indicatorColor: Color.fromARGB(255, 251, 107, 107),
          labelColor: Color.fromARGB(255, 251, 107, 107),
          unselectedLabelColor: Pallete.greyColor,
          tabs: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 10,
              child: Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text('To Do', style: TextStyle(fontSize: 12)),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 10,
              child: Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Completed', style: TextStyle(fontSize: 12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
