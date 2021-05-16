import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TodoDialog extends StatefulWidget {
  String todoTitle, todoContent;
  final String _actionButtonText;

  TodoDialog({this.todoTitle, this.todoContent})
      : _actionButtonText =
            (todoTitle.isEmpty && todoContent.isEmpty) ? 'Add' : 'Save';

  @override
  _TodoDialogState createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  TextEditingController _titleController;
  TextEditingController _contentController;
  static const double _ACTION_BUTTON_DISABLED_OPACITY = 0.3;
  double _actionButtonOpacity;

  @override
  void initState() {
    super.initState();
    _actionButtonOpacity = _ACTION_BUTTON_DISABLED_OPACITY;
    _titleController = TextEditingController(text: widget.todoTitle);
    _contentController = TextEditingController(text: widget.todoContent);

    // to dim the action button, if title/content is empty, or if it isn;t edited...
    // TODO: also do these checks, when actually inserting/updating the dbase...
    // or is same value inserts restricted by the dbase library?
    String initialTitleText = widget.todoTitle;
    String initialContentText = widget.todoContent;
    Function actionButtonOpacityHandler = () {
      setState(() {
        if ((_titleController.text.trim().isNotEmpty ||
                _contentController.text.trim().isNotEmpty) &&
            ((_titleController.text.trim() != initialTitleText) ||
                (_contentController.text.trim() != initialContentText)))
          _actionButtonOpacity = 1;
        else
          _actionButtonOpacity = _ACTION_BUTTON_DISABLED_OPACITY;
      });
    };
    _titleController.addListener(actionButtonOpacityHandler);
    _contentController.addListener(actionButtonOpacityHandler);
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
                border: OutlineInputBorder(),
                hintText: 'Enter title',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              maxLines: 5,
              controller: _contentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter content',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Opacity(
              opacity: _actionButtonOpacity,
              // to dim the action button, if title/content is empty, or if it isn;t edited...
              child: ElevatedButton(
                  onPressed: () {
                    // no need to check... these will be checked while adding widgets (in main.dart -> _addNewTodo(..,..) function)
                    // if (!titleTxtEditController.text.isEmpty && !contentTxtEditController.text.isEmpty) {
                    widget.todoTitle = _titleController.text.trim();
                    widget.todoContent = _contentController.text.trim();
                    // }
                    Navigator.of(context).pop();
                  },
                  child: Text(widget._actionButtonText)),
            )
          ],
        ),
      ),
    );
  }
}
