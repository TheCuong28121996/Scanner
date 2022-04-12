import 'package:flutter/material.dart';

class BaseBottomSheet {
  BaseBottomSheet._internal();

  static final BaseBottomSheet _instance = BaseBottomSheet._internal();

  factory BaseBottomSheet() {
    return _instance;
  }

  void show({required BuildContext context, required Widget widget}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        builder: (contextBottomSheet) {
          return Padding(
            padding: MediaQuery.of(contextBottomSheet).viewInsets,
            child: widget,
          );
        });
  }
}

Widget headerWidget({required BuildContext context, required String title}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    padding: const EdgeInsets.symmetric(
        horizontal: 16),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close)),
        ),
        Center(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
