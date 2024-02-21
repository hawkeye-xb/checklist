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
  final String id;
  final String title;
  final List<ContentList> firstThreeItems;
  final int timestamp; // ?

  final Function(String)? onDelete;
  final Function(String)? onStar;
  final Function(String)? createDuplicate;

  const CardWidget({
    super.key,
    required this.id,
    this.title = "Card Widget",
    this.firstThreeItems = const [],
    // 日期默认1970年1月1日
    this.timestamp = 0,
    this.onDelete,
    this.onStar,
    this.createDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              height: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          // 占位
          const SizedBox(height: 8.0,),
          Flexible(
            flex: 1,
            child: ListView.builder(
              itemCount: firstThreeItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: AbsorbPointer(
                        absorbing: true,
                        child: SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: Radio(
                            groupValue: true,
                            value: firstThreeItems[index].checked,
                            onChanged: (bool? value) {},
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: firstThreeItems[index].content,
                          style: const TextStyle(
                            fontSize: 16.0,
                            height: 1.5,
                          ).merge(
                            firstThreeItems[index].checked 
                              ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.black38,)
                              : const TextStyle(color: Colors.black87),
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                    ,
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8.0,),
          Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center, // 子元素居中对齐
            children: [
              const Text(
                '02-02',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(), // Flexible用于填充空间
              ),
              GestureDetector(
                onTap: () {
                  createDuplicate?.call(id);
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                  child: const Icon(Icons.copy, size: 16.0,),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     onStar?.call(id);
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
              //     child: const Icon(Icons.star, size: 16.0,),
              //   ),
              // ),
              // TODO: not use delete, batch delete
              GestureDetector(
                onTap: () {
                  onDelete?.call(id);
                },
                child: const Icon(Icons.delete, size: 16.0,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Timestamp {
}
