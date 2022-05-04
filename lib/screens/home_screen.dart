import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pl_project/main.dart';
import 'package:pl_project/models/user.dart';
import 'package:pl_project/screens/Clubs%20Stats/clubs_stats.dart';
import 'package:pl_project/screens/Clubs%20Stats/clubs_stats_by_city.dart';
import 'package:pl_project/screens/Matches%20Stats/matches_mostWins_perSeason_screen.dart';
import 'package:pl_project/screens/Matches%20Stats/matches_stats_screen.dart';
import 'package:pl_project/screens/login_screen.dart';

import 'package:pl_project/utils/constants.dart';
import 'package:pl_project/utils/request_handler.dart';
import 'package:pl_project/widgets/big_button.dart';
import 'package:pl_project/widgets/match_review_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Matches Stats/matches_review_screen.dart';
import 'Players Stats/players_clubHist_screen.dart';
import 'Players Stats/players_nat_screen.dart';
import 'Players Stats/players_pos_screen.dart';
import 'Players Stats/players_stats_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String screenName = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String> _getReviews;
  var homeTeam = Clubs[0];
  var awayTeam = Clubs[1];
  var season = seasons[0];
  var rating = ratings[0];
  TextEditingController userReviewController = TextEditingController();
  TextEditingController userPlayerName = TextEditingController();
  String playerData = '';
  late Widget mainBodyWidget;
  late bool loggedIn;
  String userEmail = '';
  late String userUsername;
  Future<String> _future() async {
    var res = await ReqHandler.GET(path: '/reviews/all');
    print(res.statusCode);
    // print(res.body);

    return res.body;
  }

  Future<String> _getMyReviews() async {
    var res = await ReqHandler.GET(path: '/reviews?email=${userEmail}');
    print(res.statusCode);
    // print(res.body);

    return res.body;
  }

  Future<String> _searchMatchReview() async {
    var res = await ReqHandler.GET(
        path: '/reviews/match?ht=$homeTeam&at=$awayTeam&season=$season');
    print(res.statusCode);
    // print(res.body);

    return res.body;
  }

  Future<void> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedEmail = prefs.getString('email');
    final String? savedUsername = prefs.getString('username');

    if (savedEmail == null) {
      print('NULLLLL');
    } else {
      print("FROM STATE");
      userEmail = savedEmail;
      print(userEmail);
    }

    if (savedUsername == null) {
      print('NULLLLL');
    } else {
      print("FROM STATE");
      userUsername = savedUsername;
      print(userUsername);
    }
  }

  void wrapper() async {
    await isLoggedIn();
  }

  @override
  void initState() {
    _getReviews = _future();
    mainBodyWidget = matches_review_screen(getReviews: _getReviews);
    wrapper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (user == null) {
    //   Navigator.pop(context);
    //   return Container();
    // }

    Future.delayed(Duration.zero, () {
      if (userEmail == '') {
        print("TEST");
        Navigator.popUntil(
            context, ModalRoute.withName(StartScreen.screenName));
      }
    });
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: mainPurple,
          title: InkWell(
            onTap: () {
              setState(() {
                _getReviews = _future();
                mainBodyWidget = matches_review_screen(getReviews: _getReviews);
              });
            },
            child: Text('PL Project'),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: mainPurple),
              onPressed: () {
                setState(() {
                  _getReviews = _getMyReviews();
                  mainBodyWidget =
                      matches_review_screen(getReviews: _getReviews);
                });
              },
              child: Text('My Reviews'),
            ),
          ]),
      drawer: Drawer(
        child: ListView(
          controller: ScrollController(),
          children: [
            DrawerHeader(
              child: Image.asset(
                "pl_logo.png",
              ),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text(
                'Search Match Review',
                style: mainStyle,
              ),
              onTap: () async {
                Navigator.pop(context);
                await showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Center(
                            child: Dialog(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 4,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: Text(
                                          'Search for a match review',
                                          style: mainStyle,
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Home Team'),
                                                DropdownButton(
                                                  value: homeTeam,
                                                  items: Clubs.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? val) {
                                                    setState(() {
                                                      homeTeam = val!;
                                                    });
                                                    print(
                                                        "Chossen value ${val}");
                                                  },
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Away Team'),
                                                DropdownButton(
                                                  value: awayTeam,
                                                  items: Clubs.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? val) {
                                                    setState(() {
                                                      awayTeam = val!;
                                                    });
                                                    print(
                                                        "Chossen value ${val}");
                                                  },
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Season'),
                                                DropdownButton(
                                                  value: season,
                                                  items: seasons.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? val) {
                                                    setState(() {
                                                      season = val!;
                                                    });
                                                    print(
                                                        "Chossen value ${val}");
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      BigButton(
                                          title: 'Search',
                                          onPressed: () {
                                            setState(() {
                                              _getReviews =
                                                  _searchMatchReview();
                                            });
                                            Navigator.pop(context);
                                            print('pressed');
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    });
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text(
                'Write a Review',
                style: mainStyle,
              ),
              onTap: () async {
                Navigator.pop(context);
                await showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Center(
                            child: Dialog(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                height: MediaQuery.of(context).size.height / 4,
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child:
                                              Text('Search for a match review'),
                                        ),
                                        Wrap(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceAround,

                                          alignment: WrapAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Home Team',
                                                  style: mainStyle,
                                                ),
                                                DropdownButton(
                                                  value: homeTeam,
                                                  items: Clubs.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? val) {
                                                    setState(() {
                                                      homeTeam = val!;
                                                    });
                                                    print(
                                                        "Chossen value ${val}");
                                                  },
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Away Team',
                                                  style: mainStyle,
                                                ),
                                                DropdownButton(
                                                  value: awayTeam,
                                                  items: Clubs.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? val) {
                                                    setState(() {
                                                      awayTeam = val!;
                                                    });
                                                    print(
                                                        "Chossen value ${val}");
                                                  },
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Season',
                                                    style: mainStyle),
                                                DropdownButton(
                                                  value: season,
                                                  items: seasons.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? val) {
                                                    setState(() {
                                                      season = val!;
                                                    });
                                                    print(
                                                        "Chossen value ${val}");
                                                  },
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Rating',
                                                  style: mainStyle,
                                                ),
                                                DropdownButton(
                                                  value: rating,
                                                  items: ratings.map<
                                                      DropdownMenuItem<
                                                          int>>((int value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value,
                                                      child: Text(
                                                          value.toString()),
                                                    );
                                                  }).toList(),
                                                  onChanged: (int? val) {
                                                    setState(() {
                                                      rating = val!;
                                                    });
                                                    print(
                                                        "Chossen value ${val}");
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: userReviewController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              hintText: "Write your review",
                                            ),
                                          ),
                                        ),
                                        BigButton(
                                            title: 'Submit',
                                            onPressed: () async {
                                              var res = await ReqHandler.GET(
                                                  path:
                                                      '/matches/getDate?ht=${homeTeam}&at=${awayTeam}&season=${season}');

                                              var temp = jsonDecode(res.body);
                                              var date = temp[0]['date'];

                                              var body = jsonEncode({
                                                "email": "flutter@gmail.com",
                                                "matchDate": date,
                                                "homeTeam": homeTeam,
                                                "rating": rating,
                                                "textReview":
                                                    userReviewController.text,
                                                "awayTeam": awayTeam,
                                                "season": season
                                              });

                                              var createRevRes =
                                                  await ReqHandler.POST(body,
                                                      path: '/reviews');
                                              print(createRevRes.statusCode);
                                              setState(() {});
                                              // Navigator.pop(context);
                                              print('pressed');
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    });
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.trophy),
              title: Text(
                'Most Wins',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = MatchesStats(
                    statsType: 'Most Wins',
                  );
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.house_rounded),
              title: Text(
                'Most Home Wins',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = MatchesStats(
                    statsType: 'Most Home Wins',
                  );
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                'Most Wins Per Season',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = MostWinsPerSeason();
                });
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.solidSquareCaretDown),
              title: Text(
                'Most Yellow Cards',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = MatchesStats(
                    statsType: 'Most YCs',
                  );
                });
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.x),
              title: Text(
                'Most Fouls',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = MatchesStats(
                    statsType: 'Most Fouls',
                  );
                });
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.futbol),
              title: Text(
                'Most Shots',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = MatchesStats(
                    statsType: 'Most Shots',
                  );
                });
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.personRunning),
              title: Text(
                'Search Player by Name',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = PlayersStats();
                });
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.personRunning),
              title: Text(
                'Search Players by Pos',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = PlayersByPos();
                });
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.personRunning),
              title: Text(
                'Get Player Hist',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = PlayerHist();
                });
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.personRunning),
              title: Text(
                'Get Players by Nat',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = PlayersByNat();
                });
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.city),
              title: Text(
                'Get Club by Stad',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = ClubsStats();
                });
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.city),
              title: Text(
                'Get Clubs by City',
                style: mainStyle,
              ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  mainBodyWidget = ClubsStatsByCity();
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: mainStyle,
              ),
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(StartScreen.screenName));
              },
            ),
          ],
        ),
      ),
      body: mainBodyWidget,
    );
  }
}
