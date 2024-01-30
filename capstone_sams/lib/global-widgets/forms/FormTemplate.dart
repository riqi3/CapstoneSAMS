import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormTemplate extends StatefulWidget {
  Column? column;
  Widget? widget;
  bool? listviewForm;
  FormTemplate({
    super.key,
    this.column,
    this.listviewForm,
    this.widget,
  });

  @override
  State<FormTemplate> createState() => _FormTemplateState();
}

class _FormTemplateState extends State<FormTemplate> {
  Widget? listView(listview) {
    if (listview == true) {
      return widget.widget;
    }
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(Sizing.padding),
          padding: EdgeInsets.all(Sizing.padding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: widget.column,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ValueDashboard(),
      appBar: PreferredSize(
        child: TitleAppBar(
          text: '',
          iconColorLeading: Pallete.whiteColor,
          iconColorTrailing: Pallete.whiteColor,
          backgroundColor: Pallete.mainColor,
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: listView(widget.listviewForm),
    );
  }
}
