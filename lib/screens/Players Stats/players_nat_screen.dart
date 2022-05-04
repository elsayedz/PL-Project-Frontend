import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pl_project/utils/constants.dart';
import 'package:pl_project/utils/request_handler.dart';
import 'package:pl_project/widgets/big_button.dart';

class PlayersByNat extends StatefulWidget {
  const PlayersByNat({Key? key}) : super(key: key);

  @override
  _PlayersByNatState createState() => _PlayersByNatState();
}

class _PlayersByNatState extends State<PlayersByNat> {
  TextEditingController userNatChoice = TextEditingController();
  bool correctInput = true;
  bool hasPlayerData = false;
  List playerData = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("Please Choose a Nationality"),
          TextField(
            decoration: InputDecoration(
              hintText: "Make sure spelling is correct",
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
            controller: userNatChoice,
          ),
          BigButton(
              title: 'Search',
              onPressed: () async {
                var res = await ReqHandler.GET(
                    path: '/player/nationality?nat=${userNatChoice.text}');

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
              child: Column(
                children: [
                  Text(
                    'TOTAL: ${playerData.length}',
                    style: mainStyle,
                  ),
                  Flexible(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: playerData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${index.toString()}-) ${playerData[index]['name']}\n',
                                    style: mainStyle,
                                  ),
                                  Text(
                                    '\tClub: ${playerData[index]['clubName']}\n',
                                    style: mainStyle,
                                  ),
                                  Text(
                                    '\tSeason: ${playerData[index]['season']}\n',
                                    style: mainStyle,
                                  ),
                                  Divider(
                                    thickness: 3,
                                    color: mainPurple,
                                    indent:
                                        MediaQuery.of(context).size.width / 4,
                                    endIndent:
                                        MediaQuery.of(context).size.width / 4,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
