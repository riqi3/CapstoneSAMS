import 'package:capstone_sams/global-widgets/Dashboard.dart';
import 'package:flutter/material.dart';

import '../screens/home/widgets/HomeAppBar.dart';

class ValueDashboard extends StatelessWidget {
  const ValueDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Dashboard(profile: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80');
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