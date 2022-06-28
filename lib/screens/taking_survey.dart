import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:ritco_app/models/answer.dart';
import 'package:ritco_app/models/questionModel.dart';
import 'package:ritco_app/screens/landing_services.dart';
import 'package:ritco_app/services/data_manupilation.dart';
import 'package:ritco_app/widgets/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class SurveyQuestionaire extends StatefulWidget {
  const SurveyQuestionaire({Key? key});

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
    "Very disatisfied",
    "Somewhat dissatisfied",
    "Somewhat Satisfied",
    "Neither Satisfied nor disatisfied",
    "Very Satisfied",
  ];

  console(args) => print(args);

  @override
  void initState() {
    // getCredentials();
    super.initState();
  }

  // Future getCredentials() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   survedId = pref.getString('surveyId')!;
  //   username = pref.getString('username')!;
  // }

  final Stream<QuerySnapshot> surveys =
      FirebaseFirestore.instance.collection('surveys').snapshots();

  commentHandler(value) {
    setState(() {
      commentDescriptionValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final surveyIdLocal = routeArgs['surveyId'];
    // final accountUsername = routeArgs['username'];

    print('taking survey screen uid   ${routeArgs['uid']}');

    //selected survey
    _selectedSurvey.add(routeArgs['surveyData']);
    if (_selectedSurvey.isNotEmpty) {
      print('SelectedSurvey is filled');

      for (var item in _selectedSurvey[0]['surveyQuestions']) {
        identifier.add(0);
        print(item);
      }
    }

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
    void submitResponseHandler(serviceId, Uid) async {
      try {
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
          surveySubmittedSucceessfuly(context, Uid, serviceId);

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
        body: SingleChildScrollView(
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
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  )),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
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
                                _selectedSurvey[0]['surveyQuestions'][index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
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
                                                    value: int.parse(quest.id),
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
                                                            _selectedSurvey[0][
                                                                    'surveyQuestions']
                                                                [
                                                                index]] = value;
                                                        //debug check answers
                                                        print(
                                                            selectedAnswersData);
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
              FutureBuilder<DocumentSnapshot>(
                  future: RitcoAPI().userSnapShot(uid: routeArgs['uid']),
                  builder: (BuildContext context, snapshot) {
                    bool waiting = true;
                    if (snapshot.connectionState == ConnectionState.done) {
                      waiting = false;
                      print(snapshot.data?['gender']);
                    }
                    return !waiting
                        ? Container(
                            margin: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  print(selectedAnswersData);
                                  // submitResponseHandler(
                                  //     _selectedSurvey[0]['serviceID'],
                                  //     routeArgs['uid']);
                                  //sunbmit survey
                                  try {
                                    RitcoAPI().setDocMergeSurveys(
                                        docId: routeArgs['surveyId'],
                                        data: {
                                          'answers': {
                                            '${routeArgs['uid']}-${DateTime.now()}':
                                                {
                                              'choices': selectedAnswersData,
                                              'created_at': DateTime.now(),
                                              'gender':
                                                  snapshot.data?['gender'],
                                              'uid': routeArgs['uid']
                                            }
                                          }
                                        }).then((value) =>
                                        surveySubmittedSucceessfuly(
                                            context,
                                            routeArgs['uid'],
                                            _selectedSurvey[0]['serviceID']));
                                  } catch (e) {
                                    print(
                                        'failed to submite survey with error:' +
                                            e.toString());
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              title: const Text("Oooops"),
                                              content: const Text(
                                                  "Failed to submit survey, Check that you have stable internet"),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: const Text("OK"))
                                              ],
                                            ));
                                  }
                                },
                                child: Text(
                                  isSubmitting || waiting
                                      ? "Loading..."
                                      : "Submit",
                                  style: const TextStyle(color: Colors.white),
                                )),
                          )
                        : Text('Preparing for submit');
                  })
            ],
          ),
        ));
  }

  Future<dynamic> surveySubmittedSucceessfuly(
      BuildContext context, Uid, serviceId) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Submitted successfully"),
              content: const Text("Your Response has been sent successfully"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/landing-services',
                          arguments: {'uid': Uid});
                    },
                    child: const Text("Services",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home-screen',
                          arguments: {"serviceId": serviceId, 'uid': Uid});
                    },
                    child: const Text(
                      "Submit another",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ))
              ],
            ));
  }
}
