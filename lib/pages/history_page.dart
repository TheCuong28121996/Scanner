import 'package:flutter/material.dart';

import '../base/base_bottom_sheet.dart';
import 'webview_page.dart';

class HistoryBottomSheet {
  HistoryBottomSheet._internal();

  static final HistoryBottomSheet _instance = HistoryBottomSheet._internal();

  factory HistoryBottomSheet() {
    return _instance;
  }

  void show({required BuildContext context, required List<String> history}) {
    BaseBottomSheet().show(
        context: context,
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            headerWidget(context: context, title: 'Lịch sử'),
            const Divider(height: 1, color: Color(0xFFE5E5E5)),
            ...history
                .map((e) => _itemWidget(
                    link: e,
                    isLast: e == history[history.length - 1],
                    context: context))
                .toList(),
            const SizedBox(height: 20)
          ],
        ));
  }

  Widget _itemWidget(
      {required String link,
      required bool isLast,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => WebViewPage(url: link)));
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Center(
              child: Row(
                children: [
                  Text(
                    link,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon:
                          const Icon(Icons.arrow_forward_ios_rounded, size: 13))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 0.5,
                  color: !isLast
                      ? Colors.black.withOpacity(0.2)
                      : Colors.transparent),
            )
          ],
        ),
      ),
    );
  }
}
