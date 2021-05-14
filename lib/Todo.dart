class Todo {
  int ID;
  String title;
  String content;

  Todo({this.ID, this.title, this.content});

  @override
  String toString() {
    return 'Todo{ID: $ID, title: $title, content: $content}';
  }

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        ID: json["id"],
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toMap_DB() => {
        // "id": ID, // (remove ID(auto-incremented), for insertion into DB)
        "title": title,
        "content": content,
      };
}
