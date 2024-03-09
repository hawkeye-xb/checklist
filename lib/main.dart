import 'package:checklist/details.dart';
import 'package:flutter/material.dart';
import 'package:checklist/components/card.dart';
import 'package:checklist/types.dart';
import 'package:intl/intl.dart';
import 'apis/databaseHelper.dart';
import 'package:checklist/components/main/menu.dart';

import 'apis/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 确保Flutter绑定初始化
  DatabaseHelper().db; // 初始化数据库
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO：设置主题
    // final Color backgroundColor = Colors.deepPurple.shade50;
    // 使用ColorScheme.fromSeed来创建颜色方案
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      // background: backgroundColor,
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // appBarTheme: AppBarTheme(
        //   backgroundColor: backgroundColor,
        // ),
        colorScheme: colorScheme,
        useMaterial3: true,
        // scaffoldBackgroundColor: backgroundColor,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _delete = false;
  final List<int> _selectedIds = [];

  final List<CardType> _cardList = [];
  void setCardList(List<CardType> value) {
    _cardList.clear();
    _cardList.addAll(sortCardListByFavorite(value));
  }

  List<CardType> sortCardListByFavorite(List<CardType> cardType) {
    // 将数组按照favorite字段区分，分别按照updated_at排序，再合并
    List<CardType> favoriteList = cardType.where((element) => element.favorite).toList();
    List<CardType> notFavoriteList = cardType.where((element) => !element.favorite).toList();
    favoriteList.sort((a, b) => b.updated_at.compareTo(a.updated_at));
    notFavoriteList.sort((a, b) => b.updated_at.compareTo(a.updated_at));
    return [...favoriteList, ...notFavoriteList];
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper().getCardTypes().then((value) {
      setState(() {
        setCardList(value);
      });
    });
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('MyHomePage didUpdateWidget() called');
  }

  @override
  Widget build(BuildContext context) {
    void handleCreateDuplicate(int id) {
      DatabaseHelper().getCardType(id).then((value) {
        if (value != null) {
          CardType newCard = CardType(
            id: 0,
            title: '${value.title} (${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()})',
            contentList: value.contentList,
            created_at: DateTime.now().millisecondsSinceEpoch,
            updated_at: DateTime.now().millisecondsSinceEpoch,
          );
          DatabaseHelper().saveCardType(newCard).then((value) {
            DatabaseHelper().getCardTypes().then((value) {
              setState(() {
                setCardList(value);
              });
            });
          });
        }
      });
    }

    void navigateToDetailsPage(value) {
      if (value == null) { return; }
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DetailsPage(defaultCardInfo: value,);
      })).then((_) => {
        // 在这里获取新的数据并更新状态
        DatabaseHelper().getCardTypes().then((value) {
          setState(() {
            setCardList(value);
          });
        }),
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: _delete ? IconButton(
          onPressed: () {
            setState(() {
              _delete = false;
            });
          },
          icon: const Icon(Icons.close),
        ) : null,
        actions: !_delete ? [
          MainHeadMenu(
            icon: const Icon(Icons.settings),
            menuItems: [
              MenuItem(label: 'Delete', value: 'BatchDelete'),
            ],
            onItemSelected: (String value) {
              if (value == 'BatchDelete') {
                setState(() {
                  _delete = true;
                });
              }
            },
          ),
        ] : null,
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          // const Text('All Checklist cards'), // TODO: filter
          // TODO: 搜索框
          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1, // 宽高比
                ),
                itemCount: _cardList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    key: ValueKey(_cardList[index].id),
                    constraints: const BoxConstraints(minWidth: 150),
                    child: GestureDetector(
                      onTap: () {
                        navigateToDetailsPage(_cardList[index]);
                      },
                      onLongPress: () {
                        setState(() {
                          _delete = true;
                        });
                      },
                      child: CardWidget(
                        id: _cardList[index].id,
                        title: _cardList[index].title,
                        items: _cardList[index].contentList,
                        timestamp: _cardList[index].updated_at,
                        favorite: _cardList[index].favorite,
                        extraChildren: _delete ? [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: Checkbox(
                                value: _selectedIds.contains(_cardList[index].id),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedIds.add(_cardList[index].id);
                                    } else {
                                      _selectedIds.remove(_cardList[index].id);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ] : [
                          PopupMenuButton(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(Icons.more_horiz, size: 16.0,),
                            ),
                            onSelected: (String value) {
                              if (value == 'Favorite') {
                                updateFavorite(_cardList[index].id, !_cardList[index].favorite).then((value) {
                                  DatabaseHelper().getCardTypes().then((value) {
                                    setState(() {
                                      setCardList(value);
                                    });
                                  });
                                });
                              }
                              if (value == 'Duplicate') {
                                handleCreateDuplicate(_cardList[index].id);
                              }
                              if (value == 'Delete') {
                                DatabaseHelper().deleteCardType(_cardList[index].id).then((value) {
                                  DatabaseHelper().getCardTypes().then((value) {
                                    setState(() {
                                      setCardList(value);
                                    });
                                  });
                                });
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem(
                                  value: 'Favorite',
                                  child: Text('Favorite'),
                                ),
                                const PopupMenuItem(
                                  value: 'Duplicate',
                                  child: Text('Duplicate'),
                                ),
                                const PopupMenuItem(
                                  value: 'Delete',
                                  child: Text('Delete'),
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CardType newCard = CardType(
            id: 0,
            title: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
            contentList: [
              ContentList(content: ''),
            ],
            created_at: DateTime.now().millisecondsSinceEpoch,
            updated_at: DateTime.now().millisecondsSinceEpoch,
          );
          DatabaseHelper()
            .saveCardType(newCard)
            .then((value) {
              DatabaseHelper().getCardType(value)
                .then((value) {
                  if (value != null) {
                    navigateToDetailsPage(value);
                  }
                });
            });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _delete ? BottomNavigationBar(
        // currentIndex: -1, // 怎么才能默认不选择
        onTap: (int index) {
          if (index == 0) {
            // 删除
            DatabaseHelper().deleteCardTypes(_selectedIds).then((value) {
              DatabaseHelper().getCardTypes().then((value) {
                setState(() {
                  setCardList(value);
                  _delete = false;
                  _selectedIds.clear();
                });
              });
            });
          } else if (index == 1) {
            // 全选
            if (_selectedIds.length == _cardList.length) {
              setState(() {
                _selectedIds.clear();
              });
            } else {
              setState(() {
                _selectedIds.clear();
                _selectedIds.addAll(_cardList.map((e) => e.id).toList());
              });
            }
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: '删除',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add_check_outlined),
            label: '全选',
          ),
        ],
      ) : null,
    );
  }
}
