import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pl_project/utils/constants.dart';
import 'package:pl_project/utils/request_handler.dart';
import 'package:pl_project/widgets/big_button.dart';

class PlayerHist extends StatefulWidget {
  @override
  _PlayerHistState createState() => _PlayerHistState();
}

class _PlayerHistState extends State<PlayerHist> {
  TextEditingController userPlayerChoice = TextEditingController();
  bool correctInput = true;
  bool hasPlayerData = false;
  List playerData = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Please Enter Player Name"),
            TextField(
              decoration: InputDecoration(
                hintText: "Make sure spelling is correct",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: correctInput ? Colors.blue : Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: correctInput ? Colors.grey : Colors.red,
                      width: 2.0),
                ),
              ),
              controller: userPlayerChoice,
            ),
            BigButton(
                title: 'Search',
                onPressed: () async {
                  var res = await ReqHandler.GET(
                      path: '/player/hist?name=${userPlayerChoice.text}');

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
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: playerData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${index.toString()}-) ${playerData[index]['clubName']} ${playerData[index]['season']}',
                        style: mainStyle,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
