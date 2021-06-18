import 'package:flutter/material.dart';

class DetailsItem extends StatelessWidget {
  IconData icon;
  String title;
  String subtitle;

  DetailsItem(
      {@required this.icon, @required this.subtitle, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.purple,
            size: 35,
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}
