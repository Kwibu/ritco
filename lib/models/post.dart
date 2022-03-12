class Post {
  final String postId;
  final String imageFile;
  final String postTitle;
  final String postSubTitle;
  final String postDescription;

  const Post(
      {required this.postId,
      required this.postTitle,
      required this.postSubTitle,
      required this.postDescription,
      required this.imageFile});
}
