import 'package:flutter/material.dart';
import 'package:checklist/types.dart';
import 'package:flutter/services.dart';
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
  String _titleDiffHook = '';
  List<ContentList> _contentListDiffHook = [];

  final TextEditingController _titleController = TextEditingController(text: '');
  List<TextEditingController> _controllers = [];

  List<ContentList> _contentList = [];
  List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.defaultCardInfo.title;

    _contentList = widget.defaultCardInfo.contentList.map((e) => e.copyWith()).toList();
    _controllers = widget.defaultCardInfo.contentList
      .map((item) => TextEditingController(text: item.content)).toList();
    
    _focusNodes = List.generate(_contentList.length, (index) => FocusNode());

    _titleDiffHook = _titleController.text;
    _contentListDiffHook = _contentList.map((e) => e.copyWith()).toList();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    for (var controller in _controllers) {
      controller.dispose();
    }
    _titleController.dispose();
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // 对比判断是否有数据修改
  bool haveChange() {
    if (_titleController.text != _titleDiffHook) {
      return true;
    }
    // diff contentList content & checked state
    if (_contentList.length != _contentListDiffHook.length) {
      return true;
    }
    for (int i = 0; i < _contentList.length; i++) {
      if (_contentList[i].content != _contentListDiffHook[i].content) {
        return true;
      }
      if (_contentList[i].checked != _contentListDiffHook[i].checked) {
        return true;
      }
    }

    return false;
  }

  void _addTextFormField() {
    setState(() {
      FocusNode newFocusNode = FocusNode();
      _focusNodes.add(newFocusNode);

      _contentList.add(ContentList(content: '', checked: false));
      _controllers.add(TextEditingController(text: ''));
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        newFocusNode.requestFocus();
      });
    });
  }

  void _deleteTextFormField(int index) {
    setState(() {
      _contentList.removeAt(index);
      _controllers.removeAt(index);

      _focusNodes[index].unfocus();
      _focusNodes[index].dispose();
      _focusNodes.removeAt(index);
    });
  }

  Future<bool> _onWillPop() async {
    if (haveChange()) {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('remind'), // use English
            content: const Text('There are unsaved changes. Do you want to save them?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('do not', style: TextStyle(color: Colors.grey),),
              ),
              TextButton(
                onPressed: () {
                  // 保存后退出
                  saveChange().then((value) {
                    Navigator.of(context).pop(true);
                  });
                },
                child: const Text('save'),
              ),
            ],
          );
        }
      ) ?? false;
    } else {
      return true;
    }
  }

  Future<void> saveChange() async {
    // 是否需要失去焦点？
    List<Map<String, dynamic>> latestValues = _contentList.asMap().entries.map((entry) {
      int idx = entry.key;
      ContentList item = entry.value;
      return {
        // 'id': item.id,
        'checked': item.checked,
        'content': _controllers[idx].text, // new value
      };
    }).toList();

    CardType updatedCard = CardType(
      id: widget.defaultCardInfo.id,
      title: _titleController.text,
      contentList: latestValues.map((map) => ContentList(content: map['content'] ?? '', checked: map['checked'] ?? false)).toList(),
      created_at: widget.defaultCardInfo.created_at,
      updated_at: DateTime.now().millisecondsSinceEpoch,
      favorite: widget.defaultCardInfo.favorite,
    );

    await DatabaseHelper().updateCardType(updatedCard);
    // update diff hook
    _titleDiffHook = _titleController.text;
    _contentListDiffHook = _contentList.map((e) => e.copyWith()).toList();

  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: saveChange, 
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 80.0),
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(controller: _titleController,),
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
                    return Container(
                      padding: const EdgeInsets.fromLTRB(12.0, 0, 16.0, 0),
                      margin: const EdgeInsets.fromLTRB(0, 0.0, 0, 4.0), // or 8px
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Flex(
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
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: RawKeyboardListener(
                              focusNode: FocusNode(),
                              onKey: (RawKeyEvent event) {
                                if (event is RawKeyDownEvent) {
                                  if (event.logicalKey == LogicalKeyboardKey.enter) {
                                    _addTextFormField();
                                  }
                                  // 如果是删除键，且当前的content为空，就删除当前的content
                                  if (event.logicalKey == LogicalKeyboardKey.backspace) {
                                    if (_controllers[index].text.isEmpty) {
                                      _deleteTextFormField(index);
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (_focusNodes.length > index && _focusNodes[index] != null) {
                                          _focusNodes[index].requestFocus();
                                        }
                                      });
                                    }
                                  }
                                }
                              },
                              child: TextFormField(
                                focusNode: _focusNodes[index],
                                // TODO：应该是insert，而不是append。但是需要这个吗？收起键盘也合理
                                // onFieldSubmitted: (value) {
                                //   _addTextFormField();
                                // },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                controller: _controllers[index],
                                style: TextStyle(
                                  decoration: _contentList[index].checked ? TextDecoration.lineThrough : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addTextFormField,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
