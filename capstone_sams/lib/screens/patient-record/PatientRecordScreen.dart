import 'package:capstone_sams/global-widgets/SearchBarTabs.dart';
import 'package:flutter/material.dart';
import '../../global-widgets/SearchBarTabs.dart';

class PatientRecordScreen extends StatelessWidget {
  const PatientRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SearchBarTabs(),),
    );
  }
}