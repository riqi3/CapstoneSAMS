import 'package:capstone_sams/global-widgets/Dashboard.dart';
import 'package:capstone_sams/global-widgets/SearchBarTabs.dart';
import 'package:flutter/material.dart';
import '../../global-widgets/SearchBarTabs.dart';

class PatientRecordScreen extends StatelessWidget {
  const PatientRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Dashboard(
          profile:
              'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80'),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SearchBarTabs(),
        
      ),
    );
  }
}
