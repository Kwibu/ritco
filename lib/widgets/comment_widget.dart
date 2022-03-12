import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:ritco_app/models/comment.dart';
import 'package:http/http.dart' as http;

class CommentWidget extends StatefulWidget {
  String globalCommentId;
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
  List<Comment> comments = [];
  String commentContent = '';
  bool isCommentLiked = false;
  List likes = [];

  @override
  void initState() {
    super.initState();
    getCommentHandler();
  }

  void console(args) => print(args);

  openCommentHandler() {
    setState(() {
      isCommentOpen = true;
    });
  }

  void commentValue(value) {
    setState(() {
      commentContent = value;
    });
  }

// ? Sending Likes To database
  setIsLiked() async {
    await http.post(
        Uri.parse(
            'https://ritco-app-default-rtdb.firebaseio.com/likedComments.json'),
        body: json.encode({
          "isLiked": true,
          "globalcomment_id": widget.globalCommentId,
          "comment_content": commentContent,
          "username": widget.username
        }));
  }

  void addCommentHandler() {
    setState(() {
      isCommentOpen = false;
      if (commentContent.isNotEmpty) {
        comments.add(Comment(
            id: Random(4).toString(),
            username: widget.username,
            messageContent: commentContent));

        try {
          addCommentToDatabaseHandler();
        } catch (error) {
          console(error);
        }
      }
    });
  }

  // todo ADDING COMMENTS TO THE DATABASE
  void addCommentToDatabaseHandler() async {
    var response = await http.post(
        Uri.parse(
            'https://ritco-app-default-rtdb.firebaseio.com/postsComments.json'),
        body: json.encode({
          "globalcomment_id": widget.globalCommentId,
          "comment_content": commentContent,
          "username": widget.username
        }));
  }

  void getCommentHandler() async {
    try {
      var response = await http.get(Uri.parse(
          'https://ritco-app-default-rtdb.firebaseio.com/postsComments.json'));
      var transformData = jsonDecode(response.body)!;

      // List<Comment> loadedComments = [];
      transformData.forEach((commentId, commentData) {
        setState(() {
          // globalcomment_id
          if (commentData["globalcomment_id"] == widget.globalCommentId) {
            comments.add(Comment(
                id: commentData['globalcomment_id'],
                username: commentData['username'],
                messageContent: commentData['comment_content']));
          }
        });
      });

      // final selectedSingleSurvey = loadedComments
      //     .where((element) => element.id == widget.globalCommentId);
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
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/message-screen",
            arguments: {"title": widget.postTitle});
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                    CircleAvatar(child: Text(widget.postTitle.substring(0, 2))),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Text(
                                      comments[index].username,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(comments[index].messageContent),
                                  ),
                                ],
                              ),
                            )),
              ],
            ),
            isCommentOpen
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: commentValue,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Comment',
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: OutlinedButton(
                              onPressed: addCommentHandler,
                              child: const Text("Post")),
                        )
                      ],
                    ))
                : Container(),
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 13.0),
                        child: LikeButton(
                          size: 20,
                          circleColor: const CircleColor(
                              start: Color(0xff00ddff), end: Color(0xff0099cc)),
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: Color(0xff33b5e5),
                            dotSecondaryColor: Color(0xff0099cc),
                          ),
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              // FontAwesome5.thumbs_down,
                              color: isLiked ? Colors.red : Colors.grey,
                              size: 20,
                            );
                          },
                          likeCount: 665,
                        ),
                      ),
                      LikeButton(
                        size: 20,
                        circleColor: const CircleColor(
                            start: Color(0xff00ddff), end: Color(0xff0099cc)),
                        bubblesColor: const BubblesColor(
                          dotPrimaryColor: Color(0xff33b5e5),
                          dotSecondaryColor: Color(0xff0099cc),
                        ),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.thumb_down,
                            // FontAwesome5.thumbs_down,
                            color:
                                isLiked ? Colors.deepPurpleAccent : Colors.grey,
                            size: 20,
                          );
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: openCommentHandler,
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                color: Colors.black38,
                height: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
