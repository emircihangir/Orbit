import 'package:flutter/material.dart';
import 'package:orbit/main.dart';
import 'package:provider/provider.dart';

FocusNode titleInputFocusNode = FocusNode();
FocusNode contentInputFocusNode = FocusNode();

final titleInputController = TextEditingController();
final contentInputController = TextEditingController();

Widget panelView(BuildContext context) {
  titleInputFocusNode.addListener(
    () {
      if (titleInputFocusNode.hasFocus == false && selectedDot != null) {
        final updatedDot = selectedDot;
        updatedDot!.title = titleInputController.text;
        dotsBox.put(selectedDot!.id, updatedDot);
        final dots = Provider.of<DotsModel>(context, listen: false).dots;
        Provider.of<DotsModel>(context, listen: false).updateDot(dots.indexOf(selectedDot!), updatedDot);
      }
    },
  );

  contentInputFocusNode.addListener(
    () {
      if (contentInputFocusNode.hasFocus == false && selectedDot != null) {
        selectedDot!.content = contentInputController.text;
        dotsBox.put(selectedDot!.id, selectedDot!);
      }
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
