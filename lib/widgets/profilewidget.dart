import 'package:flutter/material.dart';

class UserTaskWidget extends StatelessWidget {
  String id;
  String name;
  IconData icon;
  UserTaskWidget(this.id, this.icon, this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.black, style: BorderStyle.solid, width: .3))),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(children: [
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            name,
            style: TextStyle(fontSize: 20),
          ),
        )
      ]),
    );
  }
}
