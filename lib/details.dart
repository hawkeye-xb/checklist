import 'package:flutter/material.dart';
import 'package:checklist/types.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({
    super.key,
    required this.id,
    required this.defaultCardInfo,
  });

  final String id;
  final CardType defaultCardInfo;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController _titleController = TextEditingController(text: '');
  List<TextEditingController> _controllers = [];

  List<ContentList> _contentList = [];

  // mock data
  // final CardType defaultCard = CardType(
  //   title: 'Card 1',
  //   contentList: [
  //     ContentList(id: '1', content: '车厘子', checked: true),
  //     ContentList(id: '2', content: '刮胡刀'),
  //     ContentList(id: '3', content: '手机充电器 * 2', checked: true),
  //   ],
  //   id: '1',
  // );

  @override
  void initState() {
    super.initState();
    print('DetailsPage initState() called');
    print('widget.id: ${widget.id}');
    print(widget.defaultCardInfo.title);

    _titleController.text = widget.defaultCardInfo.title;

    _contentList = widget.defaultCardInfo.contentList; // 引用还是复制？？？只存bool值？
    _controllers = widget.defaultCardInfo.contentList
      .map((item) => TextEditingController(text: item.content)).toList();
  }

  @override
  void dispose() {
    print('DetailsPage dispose() called');
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
              print('save');
              print('_titleController.text: ${_titleController.text}');
              // Navigator.of(context).pop(_editedData);
              List<Map<String, dynamic>> latestValues = _contentList.asMap().entries.map((entry) {
                int idx = entry.key;
                ContentList item = entry.value;
                return {
                  'id': item.id,
                  'checked': item.checked,
                  'content': _controllers[idx].text, // new value
                };
              }).toList();

              print('latestValues: $latestValues');
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
            const Text('02-02'),
            const SizedBox(height: 8.0,),
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
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
