import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/screens/ehr-list/EHRList.dart';
import 'package:capstone_sams/screens/home/widgets/Sections.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ValueDashboard(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ValueHomeAppBar(),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Row(
          children: [
            EHRSection(
              title: 'title',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EHRList(),
                  ),
                );
                print('object');
              },
            ),
          ],
        ),
      ),
    );
  }
}
