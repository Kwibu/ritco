import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCardContainer extends StatefulWidget {
  String surveyTitle;
  String surveyDescription;
  String id;
  String image;
  HomeCardContainer(
      this.surveyTitle, this.surveyDescription, this.id, this.image,
      {Key? key})
      : super(key: key);

  @override
  State<HomeCardContainer> createState() => _HomeCardContainerState();
}

class _HomeCardContainerState extends State<HomeCardContainer> {
  String username = '';
  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  Future getCredentials() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username')!;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("surveyId", widget.id);
        Navigator.of(context).pushNamed("/survey-details-answers",
            arguments: {"surveyId": widget.id, "username": username});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 10),
              constraints: const BoxConstraints(minHeight: 130),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        width: 50,
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            widget.surveyTitle.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(widget.surveyDescription,
                                style: const TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
