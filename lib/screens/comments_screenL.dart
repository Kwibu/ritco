import 'package:flutter/material.dart';
import 'package:ritco_app/models/post.dart';
import 'package:like_button/like_button.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Image.asset("assets/avatars/Rectangle 13.png"),
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
                    const Text("Filter"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                          shrinkWrap: true,
                          primary: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: THREADS.length,
                          itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed("/message-screen", arguments: {
                                    "title": THREADS[index].postTitle
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: CircleAvatar(
                                              child: Text(THREADS[index]
                                                  .postTitle
                                                  .substring(0, 2))),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              THREADS[index].postTitle,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              THREADS[index].postSubTitle,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ]),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          THREADS[index].postDescription,
                                          style: const TextStyle(height: 1.5),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: LikeButton(
                                                    size: 20,
                                                    circleColor:
                                                        const CircleColor(
                                                            start: Color(
                                                                0xff00ddff),
                                                            end: Color(
                                                                0xff0099cc)),
                                                    bubblesColor:
                                                        const BubblesColor(
                                                      dotPrimaryColor:
                                                          Color(0xff33b5e5),
                                                      dotSecondaryColor:
                                                          Color(0xff0099cc),
                                                    ),
                                                    likeBuilder:
                                                        (bool isLiked) {
                                                      return Icon(
                                                        Icons.favorite,
                                                        // FontAwesome5.thumbs_down,
                                                        color: isLiked
                                                            ? Colors
                                                                .deepPurpleAccent
                                                            : Colors.grey,
                                                        size: 20,
                                                      );
                                                    },
                                                    likeCount: 665,
                                                  ),
                                                ),
                                                LikeButton(
                                                  size: 20,
                                                  circleColor:
                                                      const CircleColor(
                                                          start:
                                                              Color(0xff00ddff),
                                                          end: Color(
                                                              0xff0099cc)),
                                                  bubblesColor:
                                                      const BubblesColor(
                                                    dotPrimaryColor:
                                                        Color(0xff33b5e5),
                                                    dotSecondaryColor:
                                                        Color(0xff0099cc),
                                                  ),
                                                  likeBuilder: (bool isLiked) {
                                                    return Icon(
                                                      Icons.thumb_down,
                                                      // FontAwesome5.thumbs_down,
                                                      color: isLiked
                                                          ? Colors
                                                              .deepPurpleAccent
                                                          : Colors.grey,
                                                      size: 20,
                                                    );
                                                  },
                                                  likeCount: 665,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          color: Colors.black38,
                                          height: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
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
