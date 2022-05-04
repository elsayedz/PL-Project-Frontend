import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pl_project/widgets/match_review_widget.dart';

class matches_review_screen extends StatelessWidget {
  const matches_review_screen({
    Key? key,
    required Future<String> getReviews,
  })  : _getReviews = getReviews,
        super(key: key);

  final Future<String> _getReviews;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: _getReviews,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data!);

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return MatchReviewWidget(
                      textReview: data[index]['textReview'],
                      data: data[index],
                    );
                  });
            }
            if (snapshot.hasError) {
              return Center(
                child: Container(child: Text("Failed to fetch data")),
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
