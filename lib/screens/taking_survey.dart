import 'dart:convert';
import 'dart:math';
import 'package:ritco_app/models/questionModel.dart';
import 'package:ritco_app/widgets/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SurveyQuestionaire extends StatefulWidget {
  const SurveyQuestionaire({Key? key}) : super(key: key);

  @override
  _SurveyQuestionaireState createState() => _SurveyQuestionaireState();
}

class _SurveyQuestionaireState extends State<SurveyQuestionaire> {
  final List _selectedSurvey = [];
  String survedId = '';
  int _value = 0;
  bool isLoading = false;
  var surveyAnswersArray = [];

  console(args) => print(args);

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  void getCredentials() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    survedId = pref.getString('surveyId')!;
    _getSurveyInformationHandler();
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
            "answers": surveyData['answers']
          });
        });
      });

      final selectedSingleSurvey =
          loadedSurvey.where((element) => element['id'] == survedId);

      setState(() {
        _selectedSurvey.addAll(selectedSingleSurvey);
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

  @override
  Widget build(BuildContext context) {
    console(_selectedSurvey);
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
                            _selectedSurvey[0]['surveyTitle'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            _selectedSurvey[0]['surveyDescription'],
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
                      itemCount: _selectedSurvey[0]['surveyQuestions'].length,
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
                                SizedBox(
                                  child: Column(
                                      children: QUESTIONS
                                          .map(
                                            (quest) => Row(
                                              children: [
                                                Radio(
                                                    key: ValueKey(quest.id),
                                                    value: int.parse(quest.id),
                                                    groupValue: _value,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _value = value as int;
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
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            "Other Comments",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
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
                        onPressed: () {},
                        child: const Text(
                          "  Submit  ",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
    );
  }
}
