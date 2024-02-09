class Todo {
  String noteNum;
  String title;
  String content;
  int account;
  bool isDone;
  bool? isDeleted;

  Todo({
    required this.noteNum,
    required this.title,
    required this.content,
    required this.account,
    this.isDone = false,
    this.isDeleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'noteNum': noteNum,
      'title': title,
      'content': content,
      'isDone': isDone,
      'account': account,
      'isDeleted': isDeleted,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      noteNum: json['noteNum'],
      title: json['title'],
      content: json['content'],
      isDone: json['isDone'],
      account: json['account'],
      isDeleted: json['isDeleted'],
    );
  }
}
