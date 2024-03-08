import 'package:flutter/material.dart';
import 'package:checklist/types.dart';
import 'package:intl/intl.dart';

class CardWidget extends StatelessWidget {
  final int id;
  final String title;
  final List<ContentList> items;
  final int timestamp; // ?
  final List<Widget> extraChildren;
  final bool favorite;

  const CardWidget({
    super.key,
    required this.id,
    this.title = "Card Widget",
    this.items = const [],
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
    return Stack(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0), // bottom 有more按钮提供了8.0的padding
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
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                // items每个元素的checked属性都为true时，返回true。
                if (items.every((element) => element.checked)) const Icon(Icons.done_all, size: 14.0,),
                // 展示未完成的数量
                if (!items.every((element) => element.checked)) Text(
                  '${items.where((element) => element.checked).length}/${items.length}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    height: 1.5,
                    color: Colors.black38,
                  ),
                ),
                const Spacer(), // 添加一个 Spacer 组件, 使得后面的内容靠右对齐
                if (favorite) const Icon(Icons.star, size: 14.0,),
              ],
            ),
            Flexible(
              flex: 1,
              child: ListView.builder(
                // itemCount: items.length,
                itemCount: 
                  items.length > 3
                    ? 3
                    : items.length,
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
                              value: items[index].checked,
                              onChanged: (bool? value) {},
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: RichText(
                          text: TextSpan(
                            text: items[index].content,
                            style: const TextStyle(
                              fontSize: 16.0,
                              height: 1.5,
                            ).merge(
                              items[index].checked 
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
          ],
        ),
      ),
      Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 12.0,),
            Text(
              _handleTimestamp(timestamp),
              style: const TextStyle(
                fontSize: 14.0,
                height: 1.5,
                color: Colors.black38
              ),
            ),
            Flexible(child: Container(),),
            ...extraChildren,
          ],
        ),
      ),
    ],);
    
  }
}

class Timestamp {
}
