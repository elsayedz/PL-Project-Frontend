import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pl_project/utils/constants.dart';
import 'package:pl_project/utils/request_handler.dart';
import 'package:pl_project/widgets/big_button.dart';

class MostWinsPerSeason extends StatefulWidget {
  const MostWinsPerSeason({Key? key}) : super(key: key);

  @override
  _MostWinsPerSeasonState createState() => _MostWinsPerSeasonState();
}

class _MostWinsPerSeasonState extends State<MostWinsPerSeason> {
  bool correctInput = true;
  bool hasPlayerData = false;
  List clubsData = [];
  String season = seasons[0];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Please Choose a season"),
            DropdownButton(
              value: season,
              items: seasons.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? val) {
                setState(() {
                  season = val!;
                });
                print("Chossen value ${val}");
              },
            ),
            BigButton(
                title: 'Search',
                colour: mainPurple,
                borderColor: mainPurple,
                onPressed: () async {
                  var res = await ReqHandler.GET(
                      path: '/matches/mostWinsPerSeason?season=${season}');

                  if (res.statusCode != 200) {
                    setState(() {
                      correctInput = false;
                    });
                  } else {
                    setState(() {
                      correctInput = true;
                      clubsData = jsonDecode(res.body);
                      hasPlayerData = true;
                    });
                    print(res.body);
                  }
                }),
            Visibility(
              visible: hasPlayerData,
              child: Column(
                children: [
                  Text(
                    'TOTAL: ${clubsData.length}',
                    style: mainStyle,
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: clubsData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${(index + 1).toString()}-) ${clubsData[index]['team']} Wins: ${clubsData[index]['total']}\n',
                                  style: mainStyle,
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
                          ),
                        );
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
