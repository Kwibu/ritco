import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ritco_app/colors/colorswitch.dart';
import 'package:ritco_app/screens/GettingStartedScreens/finishing_password.dart';
import 'package:ritco_app/screens/GettingStartedScreens/sign_up_started.dart';
import 'package:ritco_app/screens/chosen_screen.dart';
import 'package:ritco_app/screens/getting_started.dart';
import 'package:ritco_app/screens/home_screen.dart';
import 'package:ritco_app/screens/login_screen.dart';
import 'package:ritco_app/screens/message_screen.dart';
import 'package:ritco_app/screens/taking_survey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "firebase_options.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();

// Ideal time to initialize
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String routeNameGlobal = '';

  @override
  void initState() {
    getAvailableTokenHandler();
    super.initState();
  }

  getAvailableTokenHandler() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String? username = pref.getString('username');

    // final user = FirebaseAuth.instance.currentUser;

    dashboardChoosen() {
      var routeName = '/login';
      if (username != null) {
        return routeName = "/home-screen";
      }

      if (username == null || username == '') {
        return routeName = "/getting-Started";
      }
      return routeName;
    }

    setState(() {
      routeNameGlobal = dashboardChoosen();
    });
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor primeColor = MaterialColor(0xFF7CB211, color);

    return MaterialApp(
      title: 'Ritco Surveys',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primeColor,
      ),
      home: ChosenScreen(routeNameGlobal),
      routes: {
        // '/'
        "/getting-Started": (context) => const GettingStartedScreen(),
        "/getting-started-signup": (context) => const SignUpStarted(),
        "/sign-up-credetials": (context) => const FinishingSignUp(),
        '/login': (context) => const Login(),
        "/home-screen": (context) => const HomeScreen(),
        "/message-screen": (context) => const MessageScreen(),
        "/survey-details-answers": (context) => const SurveyQuestionaire()
      },
    );
  }
}
