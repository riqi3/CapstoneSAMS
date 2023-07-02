import 'package:capstone_sams/theme/pallete.dart';
import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({
    super.key,
    required this.title,
     
    required this.location,
    required this.deliverTime,
    required this.rating, 
    required this.press,
  });

  final String title,   location;
  final int deliverTime;
  final double rating;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      onTap: press,
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                   child: Container(
                    height:100,
                    width: 100,
                    color: Colors.amber,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20 / 2),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Pallete.redColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20 / 2),
                  child: DefaultTextStyle(
                    style: TextStyle(color: Colors.black, fontSize: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20 / 2,
                              vertical: 20 / 8),
                          decoration: BoxDecoration(
                              color: Pallete.greenColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            rating.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Spacer(),
                        Text('$deliverTime min'),
                        Spacer(),
                        CircleAvatar(
                          radius: 2,
                          backgroundColor: Pallete.mainColor,
                        ),
                        Spacer(),
                        Text('Free Delivery')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
