import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pl_project/utils/constants.dart';
import 'package:pl_project/utils/request_handler.dart';
import 'package:pl_project/widgets/big_button.dart';

class PlayersStats extends StatefulWidget {
  @override
  _PlayersStatsState createState() => _PlayersStatsState();
}

class _PlayersStatsState extends State<PlayersStats> {
  TextEditingController userPlayerName = TextEditingController();
  bool correctInput = true;
  bool hasPlayerData = false;
  List playerData = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("Please enter player name"),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter player name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: correctInput ? Colors.blue : Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: correctInput ? Colors.grey : Colors.red, width: 2.0),
              ),
            ),
            controller: userPlayerName,
          ),
          BigButton(
              title: 'Search',
              onPressed: () async {
                var res = await ReqHandler.GET(
                    path: '/player?name=${userPlayerName.text}');

                if (res.statusCode != 200) {
                  setState(() {
                    correctInput = false;
                  });
                } else {
                  setState(() {
                    correctInput = true;
                    playerData = jsonDecode(res.body);
                    hasPlayerData = true;
                  });
                  print(res.body);
                }
              }),
          Visibility(
            visible: hasPlayerData,
            child: Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: playerData.length,
                itemBuilder: (context, index) {
                  print('Before');
                  var temp = playerData[index]['dateOfBirth'];
                  String birthDay = temp.substring(0, temp.indexOf('T'));
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Name: ${playerData[index]['name']}',
                          style: mainStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Date Of Birth: $birthDay',
                          style: mainStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Nationality: ${playerData[index]['nationality']}',
                          style: mainStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Height: ${playerData[index]['height']} cm',
                          style: mainStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Weight: ${playerData[index]['weight']} kg',
                          style: mainStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Position: ${playerData[index]['position']}',
                          style: mainStyle,
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: 3,
                    color: mainPurple,
                    indent: MediaQuery.of(context).size.width / 4,
                    endIndent: MediaQuery.of(context).size.width / 4,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
