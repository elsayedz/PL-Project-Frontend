import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pl_project/utils/constants.dart';
import 'package:pl_project/utils/request_handler.dart';
import 'package:pl_project/widgets/big_button.dart';

class ClubsStatsByCity extends StatefulWidget {
  const ClubsStatsByCity({Key? key}) : super(key: key);

  @override
  _ClubsStatsByCityState createState() => _ClubsStatsByCityState();
}

class _ClubsStatsByCityState extends State<ClubsStatsByCity> {
  TextEditingController userChosenCity = TextEditingController();
  bool correctInput = true;
  bool hasClubData = false;
  List clubData = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Please Enter City Name"),
            TextField(
              decoration: InputDecoration(
                hintText:
                    "Make sure spelling is correct and capitalize first letters of name. Try London or Manchester",
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
              controller: userChosenCity,
            ),
            BigButton(
                title: 'Search',
                onPressed: () async {
                  var res = await ReqHandler.GET(
                      path: '/club/city?city=${userChosenCity.text}');

                  if (res.statusCode != 200) {
                    setState(() {
                      correctInput = false;
                    });
                  } else {
                    setState(() {
                      correctInput = true;
                      clubData = jsonDecode(res.body);
                      hasClubData = true;
                    });
                    print(res.body);
                  }
                }),
            Visibility(
              visible: hasClubData,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: clubData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text("Stadium Name: ${clubData[index]["stadiumName"]}",
                            style: mainStyle),
                        Text("Address Name: ${clubData[index]["addressName"]}",
                            style: mainStyle),
                        Text("Street: ${clubData[index]["street"]}",
                            style: mainStyle),
                        Text("City: ${clubData[index]["city"]}",
                            style: mainStyle),
                        Text("ZipCode: ${clubData[index]["zipCode"]}",
                            style: mainStyle),
                        Text("Capacity: ${clubData[index]["capacity"]}",
                            style: mainStyle),
                        Text(
                            "Record League Attendance: ${clubData[index]["recordLeagueAttendance"]}",
                            style: mainStyle),
                        Text("Pitch Length: ${clubData[index]["pitchL"]}",
                            style: mainStyle),
                        Text("Pitch Width: ${clubData[index]["pitchW"]}",
                            style: mainStyle),
                        Text(
                            "Building Date: ${clubData[index]["buildingDate"]}",
                            style: mainStyle),
                        Text("Home Club: ${clubData[index]["homeClub"]}",
                            style: mainStyle),
                        Text("Club Name: ${clubData[index]["clubName"]}",
                            style: mainStyle),
                        Text(
                          "Website: ${clubData[index]["website"]}",
                          style: mainStyle,
                          textAlign: TextAlign.justify,
                        ),
                        Divider(
                          thickness: 3,
                          color: mainPurple,
                          indent: MediaQuery.of(context).size.width / 4,
                          endIndent: MediaQuery.of(context).size.width / 4,
                        )
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
