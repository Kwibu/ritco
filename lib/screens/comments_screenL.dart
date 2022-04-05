import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ritco_app/models/comment.dart';
import 'package:ritco_app/models/post.dart';
import 'package:ritco_app/widgets/comment_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool isLoading = false;
  // List comments = [];
  List<Post> THREADS = [];
  String username = '';
  List<Likes> likes = [];

  @override
  void initState() {
    // TODO: implement initState
    getCredentials();

    super.initState();
  }

  Future getCredentials() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username')!;
    _getCommentsHandler();
  }

  void _getCommentsHandler() async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await http.get(Uri.parse(
          'https://ritco-app-default-rtdb.firebaseio.com/comments.json'));
      var transformData = jsonDecode(response.body)!;
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
      }

      transformData.forEach((surveyId, surveyData) {
        setState(() {
          THREADS.add(Post(
              postId: surveyId,
              postTitle: surveyData["username"],
              postSubTitle: surveyData["userEmail"],
              postDescription: surveyData["commentDescription"],
              imageFile: "imageFile"));
        });
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
    print(likes);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Image.network(
                        "https://media.licdn.com/media/AAYQAQSOAAgAAQAAAAAAAB-zrMZEDXI2T62PSuT6kpB6qg.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 120.0),
                    child: Row(
                      children: const [
                        Text(
                          'RITCO',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(74, 48, 109, 1)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Comments",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: isLoading
                          ? SizedBox(
                              height: isLoading
                                  ? MediaQuery.of(context).size.height * 0.8
                                  : null,
                              child: const Center(
                                  child: CircularProgressIndicator()))
                          : THREADS.isEmpty && isLoading == false
                              ? SizedBox(
                                  height: isLoading
                                      ? MediaQuery.of(context).size.height
                                      : null,
                                  child: const Center(
                                      child:
                                          Text("There is no comment here yet")))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  primary: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: THREADS.length,
                                  itemBuilder: (context, index) =>
                                      CommentWidget(
                                          THREADS[index].postId,
                                          username,
                                          THREADS[index].postTitle,
                                          THREADS[index].postSubTitle,
                                          THREADS[index].postDescription)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
