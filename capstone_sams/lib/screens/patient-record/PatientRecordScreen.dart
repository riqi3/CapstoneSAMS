import 'package:capstone_sams/declare/ValueDeclaration.dart';
  
import 'package:flutter/material.dart';

import '../../global-widgets/search-bar/SearchBarTabs.dart';
 

class PatientRecordScreen extends StatelessWidget {
  const PatientRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ValueDashboard(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SearchBarTabs(),
        
      ),
    );
  }
}
