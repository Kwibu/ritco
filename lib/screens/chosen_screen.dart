import 'package:flutter/material.dart';

class ChosenScreen extends StatefulWidget {
  String routePage;
  ChosenScreen(this.routePage, {Key? key}) : super(key: key);

  @override
  State<ChosenScreen> createState() => _ChosenScreenState();
}

class _ChosenScreenState extends State<ChosenScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    nextPage();
  }

  void nextPage() {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      Navigator.of(context).pushNamed(widget.routePage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
