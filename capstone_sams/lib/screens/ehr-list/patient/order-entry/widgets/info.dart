import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:flutter/material.dart';

class MagnifyIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: Pallete.palegrayColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              content: Text(
                " \n When inputting a symptom, please refer to the suggested referenced symptom list.",
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Pallete.mainColor),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 20,
            color: const Color.fromARGB(255, 93, 87, 87),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }
}
