import 'package:flutter/material.dart';

class User with ChangeNotifier {
  late String email = "";
  late String username;
  late int age;
  late String gender;
  late String birthdate;
  late String supportClub;

  void setEmail(String e) {
    email = e;
  }
}
