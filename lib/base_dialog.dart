import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog(
      {Key? key,
      required this.detailWidget,
      this.onClose,
      this.isShowClose = true})
      : super(key: key);
  final VoidCallback? onClose;
  final Widget detailWidget;
  final bool isShowClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: onClose,
              icon: Icon(Icons.close,
                  color: isShowClose
                      ? Colors.black
                      : Colors.transparent),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16),
              child: detailWidget),
        ],
      ),
    );
  }
}
