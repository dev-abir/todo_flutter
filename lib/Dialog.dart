import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Todo.dart';

class TodoDialog extends StatefulWidget {
  String todoTitle;
  String todoContent;
  String _actionButtonText;

  TodoDialog({this.todoTitle, this.todoContent})
      : _actionButtonText =
            (todoTitle.isEmpty && todoContent.isEmpty) ? 'Add' : 'Save';

  @override
  _TodoDialogState createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  TextEditingController _titleController;
  TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todoTitle);
    _contentController = TextEditingController(text: widget.todoContent);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _contentController.dispose();
    _titleController.dispose();
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
              controller: _titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter title'),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              maxLines: 5,
              controller: _contentController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter content'),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () {
                  // no need to check... these will be checked while adding widgets (in main.dart -> _addNewTodo(..,..) function)
                  // if (!titleTxtEditController.text.isEmpty && !contentTxtEditController.text.isEmpty) {
                  widget.todoTitle = _titleController.text;
                  widget.todoContent = _contentController.text;
                  // }
                  Navigator.of(context).pop();
                },
                child: Text(widget._actionButtonText))
          ],
        ),
      ),
    );
  }
}
