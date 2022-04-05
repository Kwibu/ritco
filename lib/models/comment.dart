class Comment {
  String id;
  String username;
  String messageContent;

  Comment(
      {required this.id, required this.username, required this.messageContent});
}

class Likes {
  String id;
  String username;
  bool isLiked;
  Likes({required this.id, required this.username, required this.isLiked});
}
