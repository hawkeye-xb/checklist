import 'package:flutter/material.dart';

class ContentList {
  final String id;
  final String content;
  final bool checked;

  const ContentList({
    required this.id,
    required this.content,
    this.checked = false,
  });
}

class CardWidget extends StatelessWidget {
  final String title;
  final List<ContentList> firstThreeItems;
  final int timestamp; // ?

  const CardWidget({
    super.key,
    this.title = "Card Widget",
    this.firstThreeItems = const [],
    // 日期默认1970年1月1日
    this.timestamp = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text("Card Widget"),
    );
  }
}

class Timestamp {
}
