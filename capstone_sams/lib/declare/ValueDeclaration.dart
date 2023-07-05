import 'package:capstone_sams/global-widgets/Dashboard.dart';
import 'package:flutter/material.dart';

import '../global-widgets/TitleAppBar.dart';
import '../screens/home/widgets/HomeAppBar.dart';
import '../theme/pallete.dart';

class ValueDashboard extends StatelessWidget {
  const ValueDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Dashboard(
        profile:
            'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80');
  }
}

class ValueHomeAppBar extends StatelessWidget {
  const ValueHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeAppBar(
      profile:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
    );
  }
}

class ValueMedNotes extends StatelessWidget {
  const ValueMedNotes({super.key, required this.tabController});
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return TitleAppBar(
      text: 'Your Notes',
      backgroundColor: Pallete.mainColor,
      iconColor: Pallete.whiteColor,
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: BottomMedNotes(tabController: tabController)),
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
          indicatorColor: Pallete.textColor,
          labelColor: Pallete.textColor,
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
