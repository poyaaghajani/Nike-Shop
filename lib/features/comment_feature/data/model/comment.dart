class Comment {
  final int id;
  final String title;
  final String content;
  final String date;
  final String email;
  bool addedComment = false;

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        date = json['date'],
        email = json['author']['email'];
}
