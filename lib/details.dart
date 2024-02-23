import 'package:flutter/material.dart';
import 'package:checklist/types.dart';
import 'apis/databaseHelper.dart';
import 'package:intl/intl.dart';


class DetailsPage extends StatefulWidget {
  const DetailsPage({
    super.key,
    // required this.id,
    required this.defaultCardInfo,
  });

  // final int id;
  final CardType defaultCardInfo;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController _titleController = TextEditingController(text: '');
  List<TextEditingController> _controllers = [];

  List<ContentList> _contentList = [];

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.defaultCardInfo.title;

    _contentList = widget.defaultCardInfo.contentList; // 引用还是复制？？？只存bool值？
    _controllers = widget.defaultCardInfo.contentList
      .map((item) => TextEditingController(text: item.content)).toList();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    _controllers.forEach((controller) => controller.dispose());
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              List<Map<String, dynamic>> latestValues = _contentList.asMap().entries.map((entry) {
                int idx = entry.key;
                ContentList item = entry.value;
                return {
                  // 'id': item.id,
                  'checked': item.checked,
                  'content': _controllers[idx].text, // new value
                };
              }).toList();
              // TODO: diff 判断，提示用户是否保存
              CardType updatedCard = CardType(
                id: widget.defaultCardInfo.id,
                title: _titleController.text,
                contentList: latestValues.map((map) => ContentList(content: map['content'] ?? '', checked: map['checked'] ?? false)).toList(),
                created_at: widget.defaultCardInfo.created_at,
                updated_at: DateTime.now().millisecondsSinceEpoch,
              );
              
              DatabaseHelper().updateCardType(updatedCard);
            }, 
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
              child: Text(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(
                  DateTime.fromMillisecondsSinceEpoch(widget.defaultCardInfo.updated_at)
                ).toString()
              ),
            ),
            Flexible(
              flex: 1,
              child: ListView.builder(
                itemCount: _contentList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Flex(
                    direction: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: Radio<bool>(
                          groupValue: true,
                          value: _contentList[index].checked,
                          toggleable: true,
                          onChanged: (bool? value) {
                            setState(() {
                              _contentList[index].checked = !_contentList[index].checked;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _controllers[index],
                          style: TextStyle(
                            decoration: _contentList[index].checked ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                      ),
                      // delete
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _contentList.removeAt(index);
                            _controllers.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _contentList.add(ContentList(content: '', checked: false));
            _controllers.add(TextEditingController(text: ''));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
