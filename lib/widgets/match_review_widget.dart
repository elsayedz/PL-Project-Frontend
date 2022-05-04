import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pl_project/utils/constants.dart';

class MatchReviewWidget extends StatelessWidget {
  final textReview;
  final data;
  MatchReviewWidget({required this.textReview, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                '${data['homeTeam']} vs ${data['awayTeam']}',
                textAlign: TextAlign.center,
                style: mainStyle,
              )),
              Expanded(
                  child: Text(
                '${data['season']}',
                style: mainStyle,
                textAlign: TextAlign.center,
              )),
              Expanded(
                  child: Text(
                'Rating: ${data['rating']}',
                style: mainStyle,
                textAlign: TextAlign.center,
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('@${data['username']}: '),
                Flexible(child: Text(textReview)),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: mainPurple,
          )
        ],
      ),
    );
  }
}
