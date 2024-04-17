import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IllnessesPagination extends StatelessWidget {
  Widget icon;
  late final dynamic onpressed;
  IllnessesPagination({
    super.key,
    required this.icon,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: TextButton(
        child: icon,
        onPressed: onpressed,
        // => {
        //   // _scrollUp(),
        //   if (currentPageIndex > 0)
        //     {
        //       setState(() {
        //         currentPageIndex -= 1;
        //       })
        //     }
        // },
      ),
    );
  }
}
