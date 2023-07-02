import 'package:capstone_sams/screens/home/widgets/Sections.dart';
import 'package:capstone_sams/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'widgets/AppBarSAMS.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: HomeAppBar(
          profile:
              'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
          textColor: Pallete.textColor,
          backgroundColor: Pallete.whiteColor,
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Row(
          children: [
            HomeSection(title: 'title',  location: 'testing 12313232', deliverTime: 122, rating: 3, press: (){
              print('object');
            })
          ],
        ),
      ),
    );
  }
}
