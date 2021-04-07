import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Todo.dart';

class TodoDialog extends StatefulWidget {
  final Todo todo;
  final String actionButtonText;

  TodoDialog({@required this.todo}) : actionButtonText = (todo.title.isEmpty && todo.content.isEmpty)? 'Add' : 'Save';

  @override
  _TodoDialogState createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  TextEditingController _titleTxtEditController;
  TextEditingController _contentTxtEditController;

  @override
  void initState() {
    super.initState();
    _titleTxtEditController = TextEditingController(text: widget.todo.title);
    _contentTxtEditController = TextEditingController(text: widget.todo.content);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _contentTxtEditController.dispose();
    _titleTxtEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _titleTxtEditController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter title'),
            ),
            SizedBox(height: 16,),
            TextField(
              maxLines: 5,
              controller: _contentTxtEditController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter content'),
            ),
            SizedBox(height: 16,),
            ElevatedButton(onPressed: () {
              // no need to check... these will be checked while adding widgets (in main.dart -> _addNewTodo(..,..) function)
              // if (!titleTxtEditController.text.isEmpty && !contentTxtEditController.text.isEmpty) {
              widget.todo.title = _titleTxtEditController.text;
              widget.todo.content = _contentTxtEditController.text;
              // }
              Navigator.of(context).pop();
            }, child: Text(widget.actionButtonText))
          ],
        ),
      ),
    );
  }
}