import 'package:flutter/material.dart';

class ChosenScreen extends StatefulWidget {
  String routePage;
  String uid;
  ChosenScreen(this.routePage, this.uid, {Key? key}) : super(key: key);

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
      Navigator.of(context)
          .pushNamed(widget.routePage, arguments: {'uid': widget.uid});
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
