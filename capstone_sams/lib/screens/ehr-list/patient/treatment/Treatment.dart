import 'package:flutter/material.dart';

class Treatment extends StatefulWidget {
  const Treatment({super.key});

  @override
  State<Treatment> createState() => _TreatmentState();
}

class _TreatmentState extends State<Treatment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      width: 100,
      height: 100,
    );
  }
}
