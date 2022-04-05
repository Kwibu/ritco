import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ritco_app/models/comment.dart';
import 'package:ritco_app/widgets/comment_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  bool isCommentOpen = false;
  List<Comment> comments = [];
  String commentContent = '';
  bool isCommentLiked = false;

  String? username;
  String? globalCommentId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCommentHandler();
    getCredentials();
  }

  Future getCredentials() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username')!;
    globalCommentId = pref.getString("global_content_id_value");
    // _getCommentsHandler();
  }

  // todo ADDING COMMENTS TO THE DATABASE
  void addCommentToDatabaseHandler() async {
    var response = await http.post(
        Uri.parse(
            'https://ritco-app-default-rtdb.firebaseio.com/postsComments.json'),
        body: json.encode({
          "globalcomment_id": globalCommentId,
          "comment_content": commentContent,
          "username": username!,
          "createdTime": DateTime.now().toString()
        }));
  }

  void getCommentHandler() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.get(Uri.parse(
          'https://ritco-app-default-rtdb.firebaseio.com/postsComments.json'));
      var transformData = jsonDecode(response.body)!;

      // List<Comment> loadedComments = [];

      transformData.forEach((commentId, commentData) {
        setState(() {
          // globalcomment_id
          if (commentData["globalcomment_id"] == globalCommentId) {
            comments.add(Comment(
                id: commentData['globalcomment_id'],
                username: commentData['username'],
                messageContent: commentData['comment_content']));
          }
        });
      });
      setState(() {
        isLoading = false;
      });
    } catch (error) {
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

  void addCommentHandler() {
    setState(() {
      isCommentOpen = false;
      if (commentContent.isNotEmpty) {
        comments.add(Comment(
            id: Random(4).toString(),
            username: username!,
            messageContent: commentContent));

        try {
          addCommentToDatabaseHandler();
        } catch (error) {
          console(error);
        }
      }
    });
  }

  void commentValue(value) {
    setState(() {
      commentContent = value;
    });
  }

  void console(args) => print(args);
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final globalCommentId = routeArgs['id'];
    final title = routeArgs['title'];
    final subtitle = routeArgs['subtitle'];
    final content = routeArgs['content'];

    void addCommentHandler() {
      setState(() {
        isCommentOpen = false;
        if (commentContent.isNotEmpty) {
          comments.add(Comment(
              id: Random(4).toString(),
              username: username!,
              messageContent: commentContent));
          _textEditingController.clear();

          try {
            addCommentToDatabaseHandler();
          } catch (error) {
            console(error);
          }
        }
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 100),
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            width: double.infinity,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommentWidget(globalCommentId!, username!, title,
                          subtitle, content),
                      comments.isEmpty
                          ? Container()
                          : ListView.builder(
                              primary: true,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 2.0),
                                          child: Text(
                                            comments[index].username,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              comments[index].messageContent),
                                        ),
                                      ],
                                    ),
                                  )),
                    ],
                  ),
          ),
          Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 0,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.68,
                        child: TextField(
                          controller: _textEditingController,
                          onChanged: commentValue,
                          // maxLines: 3,
                          // onSubmitted: ,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            border: OutlineInputBorder(),
                            hintText: 'Comment',
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: OutlinedButton(
                              onPressed: addCommentHandler,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.0),
                                child: Text("Post"),
                              )),
                        ),
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}
