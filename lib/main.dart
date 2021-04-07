import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_flutter/Dialogs.dart';
import 'dart:math';

import 'Todo.dart';

const MaterialColor THEME_COL = Colors.red;
const Color WHITE_MODE_COL = Colors.white;

void main() {
  runApp(MaterialApp(
    title: 'TODO',
    theme: ThemeData(
      primarySwatch: THEME_COL,
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  final String title = 'TODOs';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  Map<int, bool> _todosSelected;
  bool selectMode = false;

  _HomePageState() {
    /* creating some random todos for testing... */
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    for (int i = 1; i <= 100; ++i) {
      var r = Random();
      todos.add(Todo(
        ID: i,
        title: List.generate(10, (index) => _chars[r.nextInt(_chars.length)])
            .join(),
        content: List.generate(100, (index) => _chars[r.nextInt(_chars.length)])
            .join(),
      ));
    }
    /*  */

    _todosSelected = {for (Todo todo in todos) todo.ID: false};
  }

  void _cardOnTap(Todo todo) {
    // if multiple-select mode is on, tap should select the list item
    if (selectMode && _todosSelected.containsValue(true)) {
      debugPrint('Card tapped, ${todo.toString()}');
      setState(() {
        _todosSelected[todo.ID] = !_todosSelected[todo.ID];
      });
    } else {
      // stop multi-select mode, when there's no more selected items
      debugPrint('selectMode STOP');
      setState(() {
        selectMode = false;
      });

      // show dialog to edit & save...
      setState(() {
        showDialog(
          context: context,
          builder: (context) {
            return TodoDialog(todo: todo); // this class will mutate the todo object itself...
          },
        );
      });
    }
  }

  void _cardOnLongPress(Todo todo) {
    // start multiple-select mode on long press
    if (!selectMode) {
      // TODO: is this if check required?
      debugPrint('selectMode START');
      selectMode = true;
    }
    setState(() {
      _todosSelected[todo.ID] = !_todosSelected[todo.ID];
    });
  }

  void _addNewTodo(String title, String content) {
    if (!title.isEmpty && !content.isEmpty) {
      int newTodoID = todos.length + 1;
      todos.add(Todo(ID: newTodoID, title: title, content: content));
      _todosSelected[newTodoID] = false;
      debugPrint(_todosSelected.toString());
    }
  }

  // del todos on pressing the delete icon
  void _delTodos() {
    setState(() {
      _todosSelected.removeWhere((key, value) {
        // actually del those todos, which are selected...
        // TODO: internally todos list isn't in order, so we can't just delete todo at (key - 1) (weird...!?)
        todos.removeWhere((element) => value && (element.ID == key));

        return value; // return which todos are selected(if selected, then it will return true), so that they gets deleted...
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Visibility(
            visible: selectMode,
            child: IconButton(
              onPressed: _delTodos,
              icon: const Icon(Icons.delete),
              iconSize: 35.0,
              tooltip: 'Delete TODOs',
            ),
          )
        ],
      ),
      body: Scrollbar(
        thickness: 10.0,
        child: Container(
          margin: const EdgeInsets.all(5.0),
          child: ListView(
            children: todos.map((todo) {
              return Card(
                child: InkWell(
                  splashColor: THEME_COL.withAlpha(30),
                  onLongPress: () => _cardOnLongPress(todo),
                  onTap: () => _cardOnTap(todo),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            todo.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // change color on selection
                color: _todosSelected[todo.ID] ? THEME_COL : WHITE_MODE_COL,
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Todo todoObj = Todo(ID: todos.length + 1, title: '', content: '');
          showDialog(
              context: context,
              builder: (context) {
                return TodoDialog(todo: todoObj);
              }).then((value) {
            debugPrint('totk $todoObj');
            setState(() {
              _addNewTodo(todoObj.title, todoObj.content);
            });
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}