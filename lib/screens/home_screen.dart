// import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ritco_app/screens/comments_screenL.dart';
import 'package:ritco_app/screens/profile_screen.dart';
import 'package:ritco_app/widgets/home_card_container.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List _services = [];
  String userName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final Stream<QuerySnapshot> surveys =
      FirebaseFirestore.instance.collection('surveys').snapshots();

  int selectedIndex = 0;

  void _selectedPage(int index) {
    setState(() {
      selectedIndex = index;
    });
    print(selectedIndex);
  }

  Widget homeScreenUpdated(BuildContext context, serviceID) {
    var surveyCount = 0;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(169, 195, 74, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            // height: 180,
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Taking Survey",
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "How are you doing today?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 24, 68, 156),
                          ),
                        ),
                      ],
                    ),
                    // const Icon(Icons.star_outline),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Select a survey where you would like to give us feedback",
                    style: TextStyle(
                        fontSize: 16, height: 1.5, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Surveys",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        //iniput survey count;
                        // Text("surveys")
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                      ),
                      child: Container(
                        // height: 300,
                        child: StreamBuilder<QuerySnapshot>(
                            // initialData: 'Initial data',
                            stream: surveys,
                            builder: ((context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              var val = [];
                              if (snapshot.hasError) {}
                              if (snapshot.hasData) {
                                for (var survey in snapshot.data!.docs) {
                                  if (survey['serviceID'] ==
                                      serviceID['serviceId']) {
                                    val.add(survey);
                                  }
                                }

                                // val = snapshot.data!.docs;

                                surveyCount = val.length;

                                return ListView.builder(
                                  primary: true,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: val.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          SurveyItemWidget(
                                              val[index]['surveyTitle'],
                                              val[index]['surveyDescription'],
                                              val[index].id,
                                              userName,
                                              val[index]['surveyQuestions']
                                                  .length
                                                  .toString(),
                                              val[index],
                                              serviceID['uid']),
                                );
                              }

                              return const Center(
                                  child: CircularProgressIndicator());
                            })),
                      ),
                      // child: Column(
                      //   children: const [
                      //     SurveyItemWidget(),
                      //     SurveyItemWidget(),
                      //     SurveyItemWidget(),
                      //   ],
                      // ),
                    ),
                  )
                ],
              ),
              width: double.infinity,
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.70),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 233, 233, 233),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    print('Args  $args');
    // final List<Widget> _page = [
    //   homeScreenUpdated(context),
    //   const CommentScreen(),
    //   const ProfileScreen(),
    // ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(169, 195, 74, 1),
        elevation: 0.2,
        title: Text(
          'Surveys',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromRGBO(169, 195, 74, 1),
      body: homeScreenUpdated(context, args),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: _selectedPage,
      //   currentIndex: selectedIndex,
      //   fixedColor: Colors.black,
      //   unselectedItemColor: Colors.black54,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feeds'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.account_circle), label: 'Account'),
      //   ],
      // ),
    );
  }
}

class SurveyItemWidget extends StatelessWidget {
  String title;
  String description;
  String id;
  String questionLength;
  String username;
  var surveyData;
  String uid;

  SurveyItemWidget(
    this.title,
    this.description,
    this.id,
    this.username,
    this.questionLength,
    this.surveyData,
    this.uid, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('uid on survey item: $uid');
    return InkWell(
      onTap: () async {
        Navigator.of(context).pushNamed("/survey-details-answers",
            arguments: {"surveyId": id, "surveyData": surveyData, 'uid': uid});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        'assets/illustrations/employee.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.stairs_outlined),
                            Container(
                                width: MediaQuery.of(context).size.width * .55,
                                margin: const EdgeInsets.only(left: 8),
                                child: Text(
                                  description,
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          questionLength,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Text(
                        "Questions",
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
