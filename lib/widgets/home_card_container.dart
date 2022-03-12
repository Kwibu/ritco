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
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              // color: Colors.black.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        Container(width: 50, child: Image.asset(widget.image)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.surveyTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Align(
                      child: Text(widget.surveyDescription,
                          style: const TextStyle(
                            fontSize: 17,
                          )),
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
