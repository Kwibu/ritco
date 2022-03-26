import 'package:flutter/material.dart';
import 'package:ritco_app/screens/comments_screenL.dart';
import 'package:ritco_app/widgets/home_card_container.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
              // textAlign: TextAlign.center,
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _page = [
      homeScreenWidget(context),
      const CommentScreen(),
      homeScreenWidget(context),
    ];
    return Scaffold(
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
