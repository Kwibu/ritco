import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:ritco_app/models/answer.dart';
import 'package:ritco_app/models/questionModel.dart';
import 'package:ritco_app/widgets/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class SurveyQuestionaire extends StatefulWidget {
  const SurveyQuestionaire({Key? key}) : super(key: key);

  @override
  _SurveyQuestionaireState createState() => _SurveyQuestionaireState();
}

class _SurveyQuestionaireState extends State<SurveyQuestionaire> {
  final List _selectedSurvey = [];
  List<List<Question>> multipleChoices = [];

  List<int> identifier = [];

  String survedId = '';
  String emailAccount = '';
  String username = '';

  bool isLoading = false;
  bool isSubmitting = false;
  var surveyAnswersArray = [];
  int allMultipleChoicesCount = 0;
  var selectedAnswersData = {};
  late String commentDescriptionValue;

  List<String> choices = [
    //Arranging index following modulo 5,
    "Very  dissatisfied",
    "Very Satisfied",
    "Somewhat Satisfied",
    "Neither Satisfied nor Satisfied",
    "Somewhat dissatisfied"
  ];

  console(args) => print(args);

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  Future getCredentials() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    survedId = pref.getString('surveyId')!;
    username = pref.getString('username')!;
    _getSurveyInformationHandler();
  }

  final Stream<QuerySnapshot> surveys =
      FirebaseFirestore.instance.collection('surveys').snapshots();

  commentHandler(value) {
    setState(() {
      commentDescriptionValue = value;
    });
  }

  void _getSurveyInformationHandler() async {
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
            "answers": surveyData['answers'],
            "createdDTime": DateTime.now(),
          });
        });
      });

      final selectedSingleSurvey =
          loadedSurvey.where((element) => element['id'] == survedId);

      setState(() {
        _selectedSurvey.addAll(selectedSingleSurvey);
      });

      //if _selectedSurvey list is not empty
      if (_selectedSurvey.isNotEmpty) {
        print('SelectedSurvey is filled');

        for (var item in _selectedSurvey[0]['surveyQuestions']) {
          identifier.add(0);
          print(item);
        }
      }
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

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final surveyIdLocal = routeArgs['surveyId'];
    final accountUsername = routeArgs['username'];

    userAccountEmailHandler(email) {
      if (email == null || email == '') {
        return "djconfiance@gmail.com";
      } else {
        return email;
      }
    }

    // ignore: todo
    // TODO SENDING USER COMMENT TO THE DATABASE

    // ignore: todo
    // TODO SUBMITTING SURVEY TO THE DATABASE
    void submitResponseHandler() async {
      try {
        setState(() {
          isSubmitting = true;
        });

        setState(() {
          isSubmitting = true;
        });
        var response = await http.post(
            Uri.parse(
                'https://ritco-app-default-rtdb.firebaseio.com/surveysAnswers.json'),
            body: json.encode({
              "surveyId": surveyIdLocal,
              "userEmail": userAccountEmailHandler(emailAccount),
              "surveyAnswers": "$selectedAnswersData"
            }));

        if (commentDescriptionValue.isNotEmpty) {
          await http.post(
              Uri.parse(
                  'https://ritco-app-default-rtdb.firebaseio.com/comments.json'),
              body: json.encode({
                "id": surveyIdLocal,
                "userEmail": userAccountEmailHandler(emailAccount),
                "username": username,
                "commentDescription": commentDescriptionValue
              }));
        }

        var userData = json.decode(response.body);
        if (userData['error'] != null) {
          setState(() {
            isSubmitting = false;
          });

          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text("Oooops"),
                    content: Text(userData['error']['message']),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("OK"))
                    ],
                  ));
        } else {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text("Wow"),
                    content:
                        const Text("Your Response has been sent successfully"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/home-screen');
                          },
                          child: const Text("OK"))
                    ],
                  ));

          setState(() {
            isLoading = false;
          });
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        console(error);
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Oooops"),
                  content: const Text("Check your internet connection"),
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

    return Scaffold(
      appBar: appBarController(context, () {}, "Questionaire", Colors.white,
          Colors.black, Colors.black),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.8, 0.0),
                          colors: <Color>[Colors.lightGreen, Colors.green],
                          tileMode: TileMode.repeated,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      height: 150,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _selectedSurvey.isEmpty
                                ? 'Loading'
                                : _selectedSurvey[0]['surveyTitle'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            _selectedSurvey.isEmpty
                                ? 'Loading'
                                : _selectedSurvey[0]['surveyDescription'],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ],
                      )),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                      child: Text(
                        "Questions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                      primary: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _selectedSurvey.isEmpty
                          ? 0
                          : _selectedSurvey[0]['surveyQuestions'].length,
                      itemBuilder: (context, index) => Container(
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 10, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    _selectedSurvey[0]['surveyQuestions']
                                        [index],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                                //multiple choices
                                SizedBox(
                                  child: Column(
                                      children:
                                          //  multipleChoices[index]
                                          QUESTIONS
                                              .map(
                                                (quest) => Row(
                                                  children: [
                                                    Radio(
                                                        key: ValueKey(quest.id),
                                                        value:
                                                            int.parse(quest.id),
                                                        groupValue:
                                                            identifier[index],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            //index identifies which question in the array
                                                            //Value is the question weight
                                                            // print(
                                                            //     'Question index:$index');
                                                            // print(
                                                            //     'selected value: $value');
                                                            identifier[index] =
                                                                value as int;
                                                            selectedAnswersData[
                                                                index] = value;

                                                            // print(
                                                            //     selectedAnswersData);
                                                          });
                                                        }),
                                                    Text(quest.questonName)
                                                  ],
                                                ),
                                              )
                                              .toList()),
                                ),
                              ],
                            ),
                          )),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            "Other Comments",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        TextField(
                          onChanged: commentHandler,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Comment',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          submitResponseHandler();
                        },
                        child: Text(
                          isSubmitting ? "Loading..." : "Submit",
                          style: const TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
    );
  }
}
