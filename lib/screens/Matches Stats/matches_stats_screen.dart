import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pl_project/utils/constants.dart';
import 'package:pl_project/utils/request_handler.dart';
import 'package:pl_project/widgets/match_review_widget.dart';

class MatchesStats extends StatefulWidget {
  final String statsType;
  MatchesStats({required this.statsType});
  @override
  _MatchesStatsState createState() => _MatchesStatsState();
}

class _MatchesStatsState extends State<MatchesStats> {
  late Future<String> _future;
  String header = "";

  Future<String> getMostWins() async {
    var res = await ReqHandler.GET(path: '/matches/mostWins');
    print(res.body);
    if (res.statusCode == 200)
      return res.body;
    else
      return 'Failed';
  }

  Future<String> getMostHomeWins() async {
    var res = await ReqHandler.GET(path: '/matches/mostHomeWins');
    print(res.body);
    if (res.statusCode == 200)
      return res.body;
    else
      return 'Failed';
  }

  Future<String> getMostYCs() async {
    var res = await ReqHandler.GET(path: '/matches/mostYellowCards');
    print(res.body);
    if (res.statusCode == 200)
      return res.body;
    else
      return 'Failed';
  }

  Future<String> getMostFouls() async {
    var res = await ReqHandler.GET(path: '/matches/mostFouls');
    print(res.body);
    if (res.statusCode == 200)
      return res.body;
    else
      return 'Failed';
  }

  Future<String> getMostShots() async {
    var res = await ReqHandler.GET(path: '/matches/mostShots');
    print(res.body);
    if (res.statusCode == 200)
      return res.body;
    else
      return 'Failed';
  }

  void setStats() {
    if (widget.statsType == 'Most Wins') {
      header = 'TOP 10 MOST WINS';
      print(header);
      _future = getMostWins();
    } else if (widget.statsType == 'Most Home Wins') {
      header = 'TOP 10 MOST HOME WINS';
      print(header);
      _future = getMostHomeWins();
    } else if (widget.statsType == "Most YCs") {
      header = 'TEAMS WITH MOST YELLOW CARDS';
      print(header);
      _future = getMostYCs();
    } else if (widget.statsType == "Most Fouls") {
      header = 'TEAMS WITH MOST FOULS';
      print(header);
      _future = getMostFouls();
    } else if (widget.statsType == "Most Shots") {
      header = 'TEAMS WITH MOST SHOTS';
      print(header);
      _future = getMostShots();
    }
  }

  @override
  void initState() {
    super.initState();
    print('test');
    print(widget.statsType);
    setStats();
  }

  @override
  Widget build(BuildContext context) {
    setStats();
    return Center(
      child: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data.runtimeType);
              var data = jsonDecode(snapshot.data!);
              print(data.runtimeType);
              return Column(
                children: [
                  Text(
                    header,
                    style: headerStyle,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${data[index]['team']}: ',
                                    style: mainStyle,
                                  ),
                                  Text(
                                    '${data[index]['total']}',
                                    style: mainStyle,
                                  )
                                ],
                              ),
                              Divider(
                                thickness: 3,
                                color: mainPurple,
                                indent: MediaQuery.of(context).size.width / 4,
                                endIndent:
                                    MediaQuery.of(context).size.width / 4,
                              )
                            ],
                          ),
                        );
                      }),
                ],
              );
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
