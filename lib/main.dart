import 'package:flutter/material.dart';
import 'package:pl_project/screens/home_screen.dart';
import 'package:pl_project/screens/login_screen.dart';
import 'package:pl_project/screens/signup_screen.dart';
import 'package:pl_project/widgets/big_button.dart';
import 'package:pl_project/utils/constants.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => User()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartScreen(),
      routes: {
        SignUpScreen.screenName: (context) => SignUpScreen(),
        LoginScreen.screenName: (context) => LoginScreen(),
        HomeScreen.screenName: (context) => HomeScreen(),
        StartScreen.screenName: (context) => StartScreen()
      },
    );
  }
}

class StartScreen extends StatefulWidget {
  static const String screenName = "start_screen";

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/pl_logo.png",
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 4,
            ),
            BigButton(
              title: 'Sign Up',
              textColor: Colors.white,
              colour: Colors.orange,
              borderColor: Colors.orange,
              paddingHorizontal: MediaQuery.of(context).size.width / 6,
              onPressed: () {
                print('Hello');
                Navigator.pushNamed(context, SignUpScreen.screenName);
              },
            ),
            BigButton(
              title: 'Login ',
              textColor: Colors.white,
              colour: Colors.blue,
              borderColor: Colors.blue,
              paddingHorizontal: MediaQuery.of(context).size.width / 6,
              onPressed: () {
                print('Hello');
                Navigator.pushNamed(context, LoginScreen.screenName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
