import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pl_project/screens/home_screen.dart';
import 'package:pl_project/utils/constants.dart';
import 'package:pl_project/utils/request_handler.dart';
import 'package:pl_project/widgets/big_button.dart';
import '../utils/user_input_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  static const String screenName = "signup_screen";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userConfirmPasswordController = TextEditingController();
  TextEditingController userUsernameController = TextEditingController();
  TextEditingController userAgeController = TextEditingController();
  TextEditingController userGenderController = TextEditingController();
  TextEditingController userBirthdateController = TextEditingController();
  String supportClub = Clubs[0];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 32.0),
                child: Text(
                  "REGISTER",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Email"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: userEmailController,
                        validator: (val) => Validator.validateEmail(email: val),
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    const Text("Username"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: userUsernameController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    const Text("Password"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: userPasswordController,
                        obscureText: true,
                        validator: (val) =>
                            Validator.validatePassword(password: val),
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    const Text("Confirm Password"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: userConfirmPasswordController,
                        validator: (val) => Validator.validateConfirmPass(
                            password: userPasswordController.text,
                            confirmPassword: val),
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text("Age"),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  controller: userAgeController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "Age",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text("Gender"),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  controller: userGenderController,
                                  maxLength: 1,
                                  decoration: InputDecoration(
                                    hintText: "M or F",
                                    counterText: "",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text("Birthday"),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  controller: userBirthdateController,
                                  decoration: InputDecoration(
                                    hintText: "YYYY-MM-DD",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Support Club: ",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 10),
                          DropdownButton(
                            value: supportClub,
                            items: Clubs.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? val) {
                              setState(() {
                                supportClub = val!;
                              });
                              print("Chossen value ${val}");
                            },
                          ),
                        ],
                      ),
                    ),
                    BigButton(
                      paddingHorizontal: 0.0,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          print("VALIDDDDD");
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              });

                          var body = jsonEncode({
                            "email": userEmailController.text,
                            "password": userConfirmPasswordController.text,
                            "username": userUsernameController.text,
                            "age": userAgeController.text,
                            "gender": userGenderController.text,
                            "birthdate": userBirthdateController.text,
                            "supportClub": supportClub
                          });

                          var res = await ReqHandler.POST(body, path: '/users');
                          print('Response status: ${res.statusCode}');
                          print('Response body: ${res.body}');
                          if (res.statusCode == 200) {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, HomeScreen.screenName);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(
                                'email', userEmailController.text);
                            await prefs.setString(
                                'username', userUsernameController.text);
                          }
                        }
                      },
                      title: 'Sign Up',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
*
**
    "email": "hreoku@gmail.com",
    "password": "pass",
    "username": "test5543",
    "age": 21,
    "gender": "M",
    "birthdate": "2000-11-25",
    "supportClub": "Arsenal"
*
* */
