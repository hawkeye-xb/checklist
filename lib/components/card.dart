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
  final String id; // or int?
  final String title;
  final List<ContentList> firstThreeItems;
  final int timestamp; // ?

  const CardWidget({
    super.key,
    required this.id,
    this.title = "Card Widget",
    this.firstThreeItems = const [],
    // 日期默认1970年1月1日
    this.timestamp = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: const Text("Card Widget"),
    );
  }
}

class Timestamp {
}
