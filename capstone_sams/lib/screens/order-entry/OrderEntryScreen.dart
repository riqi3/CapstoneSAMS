import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/global-widgets/text-fields/Textfields.dart';
import 'package:flutter/material.dart';

import '../../theme/pallete.dart';
import '../../theme/sizing.dart';

class OrderEntryScreen extends StatefulWidget {
  const OrderEntryScreen({super.key});

  @override
  State<OrderEntryScreen> createState() => _OrderEntryScreenState();
}

class _OrderEntryScreenState extends State<OrderEntryScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController instructions = TextEditingController();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizing.appbarHeight),
        // child: SearchBarTabs(),
        child: TitleAppBar(
          text: 'Medication Order',
          iconColorLeading: Pallete.whiteColor,
          iconColorTrailing: Pallete.whiteColor,
          backgroundColor: Pallete.mainColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          top: Sizing.sectionSymmPadding,
        ),
        child: Column(
          children: [
            TextAreaField(
              controller: instructions,
              validator: 'Please provide instructions to the patient.',
              hintText: 'Instructions...',
            ),
          ],
        ),
      ),
    );
  }
}
