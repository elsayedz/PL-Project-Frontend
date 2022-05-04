import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pl_project/models/user.dart';
import 'package:pl_project/screens/signup_screen.dart';
import 'package:pl_project/utils/constants.dart';
import 'package:pl_project/widgets/big_button.dart';
import 'package:http/http.dart' as http;
import 'package:pl_project/utils/request_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String screenName = '/login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "LOGIN",
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
                      decoration: InputDecoration(
                        hintText: "Email",
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
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  BigButton(
                    title: "Login",
                    onPressed: () async {
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
                        "password": userPasswordController.text,
                      });
                      var res =
                          await ReqHandler.POST(body, path: '/users/signin');

                      print('Response status: ${res.statusCode}');
                      // print('Response body: ${res.body}');
                      if (res.statusCode == 200) {
                        var data = json.decode(res.body);
                        Navigator.pop(context);

                        context.read<User>().email = data[0]["email"];
                        context.read<User>().username = data[0]["username"];
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('email', data[0]["email"]);
                        await prefs.setString('username', data[0]["username"]);
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.screenName);
                        print("shouldn't print");
                      } else {
                        Navigator.pop(context);
                      }
                      // Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
