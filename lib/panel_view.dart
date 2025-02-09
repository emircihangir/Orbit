import 'package:flutter/material.dart';

FocusNode titleInputFocusNode = FocusNode();
FocusNode contentInputFocusNode = FocusNode();

final titleInputController = TextEditingController();
final contentInputController = TextEditingController();

Widget panelView() {
  titleInputFocusNode.addListener(
    () {
      if (titleInputFocusNode.hasFocus == false) print(titleInputController.text);
    },
  );

  contentInputFocusNode.addListener(
    () {
      if (contentInputFocusNode.hasFocus == false) print(contentInputController.text);
    },
  );

  return Column(
    children: [
      TextField(
        controller: titleInputController,
        cursorColor: Colors.grey,
        mouseCursor: SystemMouseCursors.none,
        focusNode: titleInputFocusNode,
        decoration: const InputDecoration(hintText: "Title", border: InputBorder.none),
        maxLines: 1,
        ignorePointers: true,
        style: const TextStyle(fontSize: 23),
      ),
      Expanded(
        child: TextField(
          controller: contentInputController,
          cursorColor: Colors.grey,
          mouseCursor: SystemMouseCursors.none,
          focusNode: contentInputFocusNode,
          decoration: const InputDecoration(hintText: "Content", border: InputBorder.none),
          ignorePointers: true,
          minLines: null,
          maxLines: null,
          expands: true,
        ),
      )
    ],
  );
}
