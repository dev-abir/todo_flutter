import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_flutter/Dbase.dart';
import 'package:todo_flutter/Dialog.dart';

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
  bool _selectMode = false;
  Future<List<Todo>> _data;

  Future<List<Todo>> _fetchFromDB() async {
    return DBProvider.db.getAllTodos();
  }

  @override
  void initState() {
    super.initState();
    _data = _fetchFromDB();
    _data.then((value) {
      todos = value;
      _todosSelected = {for (Todo todo in todos) todo.ID: false};
    });
  }

  void _cardOnTap(Todo todo) {
    // if multiple-select mode is on, tap should select the list item
    if (_selectMode && _todosSelected.containsValue(true)) {
      setState(() => _todosSelected[todo.ID] = !_todosSelected[todo.ID]);
    } else {
      // stop multi-select mode, when there's no more selected items
      debugPrint('selectMode STOP');
      setState(() => _selectMode = false);

      // show dialog to edit & save...
      // TODO: if new title or content is empty, delete that todo...
      TodoDialog todoDialog =
          TodoDialog(todoTitle: todo.title, todoContent: todo.content);
      showDialog(
        context: context,
        builder: (context) => todoDialog,
      ).then((value) {
        DBProvider.db.updateTodo(todo).then((value) {
          setState(() {
            // TODO: the TodoDialog class could have
            // a constructor with just a "Todo, instead of
            // title and content... the dialog class could mutate
            // the todo object... but the setState() doesn't work properly(maybe)
            // like: setState() { showDialog... ... ... ... builder: (context) {
            //           return TodoDialog(todoObj);
            //         }, }
            todo.title = todoDialog.todoTitle;
            todo.content = todoDialog.todoContent;
          });
        });
      });
    }
  }

  void _cardOnLongPress(Todo todo) {
    // start multiple-select mode on long press
    if (!_selectMode) {
      // TODO: is this if check required?
      debugPrint('selectMode START');
      _selectMode = true;
    }
    setState(() {
      _todosSelected[todo.ID] = !_todosSelected[todo.ID];
    });
  }

  void _addNewTodo(String title, String content) {
    if (title.isNotEmpty || content.isNotEmpty) {
      DBProvider.db
          .insertTodo(Todo(title: title, content: content))
          .then((newTodoID) {
        setState(() {
          todos.add(Todo(ID: newTodoID, title: title, content: content));
          _todosSelected[newTodoID] = false;
        });
      });
    }
  }

  // del todos on pressing the delete icon
  void _delTodos() {
    // TODO: can be made more efficient?
    List<int> todoIDsToBeDeleted = [];
    _todosSelected
        .forEach((key, value) => {if (value) todoIDsToBeDeleted.add(key)});
    DBProvider.db.deleteMultipleTodosWithID(todoIDsToBeDeleted).then((value) {
      setState(() {
        for (int ID in todoIDsToBeDeleted) {
          _todosSelected.remove(ID);
          todos.removeWhere((element) => element.ID == ID);
        }
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
            visible: _selectMode,
            child: IconButton(
              onPressed: _delTodos,
              icon: const Icon(Icons.delete),
              iconSize: 35.0,
              tooltip: 'Delete TODOs',
            ),
          )
        ],
      ),
      body: FutureBuilder(
        // TODO: ?? initialData:
        future: _data,
        builder: (context, snapshot) => snapshot.hasData
            ? _buildWidget(snapshot.data)
            : Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TodoDialog todoDialog = TodoDialog(
            todoTitle: '',
            todoContent: '',
          );
          showDialog(
            context: context,
            builder: (context) => todoDialog,
          ).then((value) {
            _addNewTodo(todoDialog.todoTitle, todoDialog.todoContent);
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildWidget(List<Todo> data) {
    //TODO: parameter (data) hasn't been used here...
    return Scrollbar(
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
                        child: Text(todo.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
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
    );
  }
}
