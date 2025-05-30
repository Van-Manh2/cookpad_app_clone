import 'package:cookpad_app_clone/models/search.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecentSearch extends StatelessWidget {
  final Search search;

  const RecentSearch({super.key, required this.search});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.timer_sharp, size: 25),
          SizedBox(width: 10),
          Text(
            search.keyword,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Text(
            timeago.format(search.timestamp, locale: 'vi'),
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
