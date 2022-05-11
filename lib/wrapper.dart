import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ritco_app/screens/getting_started.dart';
import 'package:ritco_app/screens/home_screen.dart';
import 'package:ritco_app/screens/landing_services.dart';
import 'package:ritco_app/services/data_manupilation.dart';

class Wrapper extends StatelessWidget {
  static String route = "wrapper";

  // Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<RitcoUser>(context);

    // return either home or authenticate widget based on listening
    if (user.uid == null) {
      return const GettingStartedScreen();
    } else {
      print(user.uid);
      return const ServicesProvider();
    }
  }
}
