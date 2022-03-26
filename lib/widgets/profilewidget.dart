import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTaskWidget extends StatelessWidget {
  String id;
  String name;
  IconData icon;
  UserTaskWidget(this.id, this.icon, this.name, {Key? key}) : super(key: key);

  void logoutHandler(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('username');
    pref.setString("logout", "loggedout");
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void changeProfileStatus(BuildContext context) {
    if (id == '3') {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Are you sure?"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        logoutHandler(context);
                      },
                      child: const Text(
                        "Ok",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(id);
        changeProfileStatus(context);
      },
      child: Container(
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
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
