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
    getUserCredentials();
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

  void getUserCredentials() async {
    _getAllSurveyInformationHandler();
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String? username = pref.getString('firstname');
    setState(() {
      userName = username.toString();
    });
  }

  void _getAllSurveyInformationHandler() async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await http.get(Uri.parse(
          'https://ritco-app-default-rtdb.firebaseio.com/surveys.json'));

      var transformData = jsonDecode(response.body)!;
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
      }

      final loadedSurvey = [];
      transformData.forEach((surveyId, surveyData) {
        setState(() {
          loadedSurvey.add({
            "id": surveyId,
            "surveyTitle": surveyData['surveyTitle'],
            "surveyDescription": surveyData['surveyDescription'],
            "surveyQuestions": surveyData['surveyQuestions'],
            "userEmail": surveyData['userEmail'],
          });
        });
      });

      setState(() {
        _services.addAll(loadedSurvey);
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print(error);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Oooops"),
                content: const Text("Invalid Data"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("OK"))
                ],
              ));
    }
  }

  Widget homeScreenWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(
          top: 50,
          right: 20,
          left: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi $userName !",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text("How are you doing today?"),
                  ],
                ),
                const Icon(Icons.star_outline),
              ],
            ),
            Stack(children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset("assets/illustrations/Group 13.png"),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width * 0.5,
                top: 30,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Transport yourself and your assets conveniently",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text("Give your feedback"),
                    ],
                  ),
                ),
              )
            ]),
            //? Adding Services
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Text(
                "Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Text(
              "Try to fill survey accordingly how you feed about our company it will help us to manage any problem you have ",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            _services.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(child: CircularProgressIndicator()))
                : ListView.builder(
                    primary: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _services.length,
                    itemBuilder: (BuildContext context, int index) =>
                        HomeCardContainer(
                            _services[index]['surveyTitle'],
                            _services[index]['surveyDescription'],
                            _services[index]['id'],
                            "assets/illustrations/employee.png")),

            Container(
              child: StreamBuilder<QuerySnapshot>(
                  // initialData: 'Initial data',
                  stream: surveys,
                  builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    var val = [];
                    if (snapshot.hasError) {}
                    if (snapshot.hasData) {
                      val = snapshot.data!.docs;

                      return ListView.builder(
                          primary: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: val.length,
                          itemBuilder: (BuildContext context, int index) =>
                              HomeCardContainer(
                                  val[index]['surveyTitle'],
                                  val[index]['surveyDescription'],
                                  val[index].id,
                                  "assets/illustrations/employee.png"));
                    }

                    return Text(val[0]['surveyQuestions']);
                  })),
            )
          ],
        ),
      ),
    );
  }

  Widget homeScreenUpdated(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(169, 195, 74, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            height: 180,
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi $userName !",
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
                    const Icon(Icons.star_outline),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Try to fill survey accordingly how you feed about our company it will help us to manage any problem you have ",
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
                      children: const [
                        Text(
                          "Surveys",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text("3 surveys")
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
                                val = snapshot.data!.docs;

                                return ListView.builder(
                                    primary: true,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                    .toString()));
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
    final List<Widget> _page = [
      homeScreenUpdated(context),
      const CommentScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: const Color.fromRGBO(169, 195, 74, 1),
      body: _page[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        currentIndex: selectedIndex,
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feeds'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }
}

class SurveyItemWidget extends StatelessWidget {
  String title;
  String description;
  String id;
  String questionLength;
  String username;

  SurveyItemWidget(
    this.title,
    this.description,
    this.id,
    this.username,
    this.questionLength, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("surveyId", id);
        Navigator.of(context).pushNamed("/survey-details-answers",
            arguments: {"surveyId": id, "username": username});
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
                      child: Image.network(
                        "https://www.pngitem.com/pimgs/m/258-2585236_zoho-survey-zoho-survey-logo-hd-png-download.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.stairs_outlined),
                            Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Text(description))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 24, 68, 156),
                      borderRadius: BorderRadius.circular(10)),
                  height: 35,
                  width: 40,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                )
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
                          icon: const Icon(Icons.comment_outlined))
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
