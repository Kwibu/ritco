import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:ritco_app/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentWidget extends StatefulWidget {
  String globalCommentId;
  // List<Likes> likes;
  String username;
  String postTitle;
  String postSubTitle;
  String postDescription;
  CommentWidget(this.globalCommentId, this.username, this.postTitle,
      this.postSubTitle, this.postDescription,
      {Key? key})
      : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool isCommentOpen = false;
  String dataUser = '';
  bool isLiked = false;
  bool isNotLiked = false;
  List<Comment> comments = [];
  String commentContent = '';
  bool isCommentLiked = false;
  Map likes = {};
  Map unliked = {};
  bool isInDatabaseLiked = false;
  List numberOfLikes = [];
  List numberOfDislike = [];
  int likesNumberFinal = 0;

  @override
  void initState() {
    super.initState();
    getAllLikesHandler();
    getAllDislikesHandler();
  }

  void console(args) => print(args);

// ? Sending Likes To database
  setIsLiked() async {
    await http.post(
        Uri.parse(
            'https://ritco-app-default-rtdb.firebaseio.com/likedComments.json'),
        body: json.encode({
          "isLiked": true,
          "globalcomment_id": widget.globalCommentId,
          "comment_content": commentContent,
          "username": widget.username,
          "createdTime": DateTime.now().toString()
        }));
  }

  likeButtonHandler() {
    if (isInDatabaseLiked == true) {
      return;
    }
    setState(() {
      likesNumberFinal = numberOfLikes.length + 1;
      isLiked = !isLiked;
    });
    try {
      addLikeToDatabaseHandler();
    } catch (error) {
      print(error);
    }
  }

  commentDislikeButton() {
    setState(() {
      isNotLiked = !isNotLiked;
    });
    try {
      addDisLikeToDatabaseHandler();
    } catch (error) {
      console(error);
    }
  }

  // todo ADDING DISLIKE TO THE DATABASE
  void addDisLikeToDatabaseHandler() async {
    var response = await http.post(
        Uri.parse(
            'https://ritco-app-default-rtdb.firebaseio.com/dislikedComments.json'),
        body: json.encode({
          "globalcomment_id": widget.globalCommentId,
          "username": widget.username,
          "dislikedStatus": true,
          "createdTime": DateTime.now().toString()
        }));
  }

  // todo ADDING COMMENTS TO THE DATABASE
  void addLikeToDatabaseHandler() async {
    var response = await http.post(
        Uri.parse(
            'https://ritco-app-default-rtdb.firebaseio.com/likedComments.json'),
        body: json.encode({
          "globalcomment_id": widget.globalCommentId,
          "username": widget.username,
          "likedStatus": true,
          "createdTime": DateTime.now().toString()
        }));
  }

  void getAllLikesHandler() async {
    try {
      var response = await http.get(Uri.parse(
          'https://ritco-app-default-rtdb.firebaseio.com/likedComments.json'));
      var transformData = jsonDecode(response.body)!;

      transformData.forEach((likeId, likeData) {
        setState(() {
          if (likeData['globalcomment_id'] == widget.globalCommentId) {
            likes = {"username_from_database": likeData['username']};
            numberOfLikes
                .add(likeData["globalcomment_id"] == widget.globalCommentId);
            if (likeData['likedStatus'] == true) {
              isInDatabaseLiked = true;
            }
          }
        });
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

  void getAllDislikesHandler() async {
    try {
      var response = await http.get(Uri.parse(
          'https://ritco-app-default-rtdb.firebaseio.com/dislikedComments.json'));
      var transformData = jsonDecode(response.body)!;

      transformData.forEach((likeId, unlikeData) {
        setState(() {
          if (unlikeData['globalcomment_id'] == widget.globalCommentId) {
            unliked = {"username_from_database": unlikeData['username']};
            numberOfDislike
                .add(unlikeData["globalcomment_id"] == widget.globalCommentId);
            if (unlikeData['likedStatus'] == true) {
              isInDatabaseLiked = true;
            }
          }
        });
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

  @override
  Widget build(BuildContext context) {
    print(unliked);
    return InkWell(
      onTap: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('global_content_id_value', widget.globalCommentId);
        await Navigator.of(context).pushNamed("/message-screen", arguments: {
          "id": widget.globalCommentId,
          "title": widget.postTitle,
          "subtitle": widget.postSubTitle,
          "content": widget.postDescription
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Material(
          elevation: 2,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            padding:
                const EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                        child: Text(widget.postTitle.substring(0, 0))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.postTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        widget.postSubTitle,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    widget.postDescription,
                    style: const TextStyle(height: 1.5),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: comments.isEmpty
                          ? null
                          : Text(
                              "View all Comments (${comments.length.toString()})",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                    ),
                  ],
                ),
                Container(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 13.0),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        likeButtonHandler();
                                      },
                                      // ignore: unrelated_type_equality_checks
                                      icon: isLiked ||
                                              likes['username_from_database'] ==
                                                  widget.username
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite_border_outlined)),
                                  Text(numberOfLikes.length.toString())
                                ],
                              )),
                          IconButton(
                              onPressed: () {
                                commentDislikeButton();
                              },
                              icon: isNotLiked ||
                                      unliked['username_from_database'] ==
                                          widget.username
                                  ? const Icon(Icons.thumb_down)
                                  : const Icon(Icons.thumb_down_alt_outlined)),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/mesage-screen');
                                  },
                                  icon: const Icon(
                                    Icons.comment,
                                    size: 20,
                                    color: Colors.grey,
                                  )),
                              Text(
                                comments.length.toString(),
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: Container(
                //     color: Colors.black38,
                //     height: 1,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
