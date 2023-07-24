class Todo {
  String noteNum;
  String title;
  String content;
  String account;
  bool isDone;

  Todo({
    required this.noteNum,
    required this.title,
    required this.content,
    required this.account,
    this.isDone = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      noteNum: json['noteNum'],
      title: json['title'],
      content: json['content'],
      isDone: json['iscomplete'],
      account: json['account'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteNum': noteNum,
      'title': title,
      'content': content,
      'account': account,
    };
  }
}
