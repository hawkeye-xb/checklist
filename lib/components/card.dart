import 'package:flutter/material.dart';
import 'package:checklist/types.dart';
import 'package:intl/intl.dart';

class CardWidget extends StatelessWidget {
  final int id;
  final String title;
  final List<ContentList> firstThreeItems;
  final int timestamp; // ?
  final List<Widget> extraChildren;
  final bool favorite;

  const CardWidget({
    super.key,
    required this.id,
    this.title = "Card Widget",
    this.firstThreeItems = const [],
    // 日期默认1970年1月1日
    this.timestamp = 0,
    this.extraChildren = const [],
    this.favorite = false,
  });

  /*
    处理时间戳函数。入参时间戳
    - [] 日期显示规则
      - [] 一天内：展示小时
      - [] 超过一天：展示月日
      - [] 超过一年：展示年月日
  */ 
  String _handleTimestamp(int timestamp) {
    DateTime now = DateTime.now();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (now.year == date.year) {
      if (now.month == date.month && now.day == date.day) {
        return DateFormat.Hm().format(date);
      } else {
        return DateFormat.Md().format(date);
      }
    } else {
      return DateFormat.yMd().format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0), // bottom 有more按钮提供了8.0的padding
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
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                height: 1.5,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // 占位
          // const SizedBox(height: 8.0,),
          // 状态展示
          Flex(
            direction: Axis.horizontal,
            children: [
              if (favorite) const Icon(Icons.star, size: 14.0,),
              if (!favorite) const Icon(Icons.star_border, size: 14.0,), // TODO: remove
            ],
          ),
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
              Text(
                _handleTimestamp(timestamp),
                // '2024/11/12',
                style: const TextStyle(
                  fontSize: 14.0,
                  height: 1.5,
                  color: Colors.black38
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(), // Flexible用于填充空间
              ),
              const SizedBox(width: 4.0,),
              ...extraChildren,
            ],
          ),
        ],
      ),
    );
  }
}

class Timestamp {
}
