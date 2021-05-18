class Todo {
  int id;
  String title;
  String content;

  Todo({this.id, this.title, this.content});

  @override
  String toString() {
    return 'Todo{ID: $id, title: $title, content: $content}';
  }

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json["id"],
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toMap_DB() => {
        // "id": ID, // (remove ID(auto-incremented), for insertion into DB)
        "title": title,
        "content": content,
      };
}
