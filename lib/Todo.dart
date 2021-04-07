import 'package:flutter/widgets.dart';

class Todo {

  final int ID;
  String title;
  String content;

  Todo({@required this.ID, this.title, this.content});

  @override
  String toString() {
    return 'Todo{ID: $ID, title: $title, content: $content}';
  }
}