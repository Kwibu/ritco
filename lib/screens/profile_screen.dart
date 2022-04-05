import 'package:flutter/material.dart';
import 'package:ritco_app/models/userTask.dart';
import 'package:ritco_app/widgets/profilewidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username = 'ABC';
  String? useraccount = '';
  @override
  void initState() {
    super.initState();

    void getUser() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        username = pref.getString("username").toString();
        useraccount = pref.getString("useraccount").toString();
      });
    }

    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 24),
                constraints: const BoxConstraints(minHeight: 200),
                color: Colors.lightGreen,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back)),
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      username!.toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.email,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          useraccount!,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40),
              child: ListView.builder(
                  primary: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userList.length,
                  itemBuilder: (context, index) => UserTaskWidget(
                      userList[index].id,
                      userList[index].icon,
                      userList[index].name)),
            ),
          ],
        )),
        Positioned(
            width: MediaQuery.of(context).size.width,
            top: 160,
            child: CircleAvatar(
              minRadius: 40,
              child: Text(
                username!.substring(0, 2).toUpperCase(),
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              backgroundColor: const Color.fromARGB(255, 158, 156, 156),
            )),
      ],
    );
  }
}
