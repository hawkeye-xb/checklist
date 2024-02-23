import 'package:checklist/details.dart';
import 'package:flutter/material.dart';
import 'package:checklist/components/card.dart';
import 'package:checklist/types.dart';
import 'apis/databaseHelper.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  final List<CardType> _cardList = [];

  @override
  void initState() {
    super.initState();
    print('MyHomePage initState() called');
    DatabaseHelper().getCardTypes().then((value) {
      print('getCardTypes() called');
      // print(value[0].id); // []
      setState(() {
        _cardList.addAll(value);
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
    print('main app builded'); // 从路由返回不触发

    void handleCardDelete(int id) {
      print('delete card id: $id'); // double checked
    }

    void handleCardCollect(int id) {
      print('collect card id: $id'); // double checked
    }

    void navigateToDetailsPage(value) {
      if (value == null) { return; }
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DetailsPage(defaultCardInfo: value,);
      })).then((value) => {
        print('pop from details page'),
      });
    }

    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(16.0),
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
                    constraints: const BoxConstraints(minWidth: 150),
                    child: GestureDetector(
                      onTap: () {
                        navigateToDetailsPage(_cardList[index]);
                      },
                      onLongPress: () {
                        print('long press');
                        // 进入批量删除状态，长按的id默认选中
                      },
                      child: CardWidget(
                        id: _cardList[index].id,
                        title: _cardList[index].title,
                        firstThreeItems: _cardList[index].contentList,
                        timestamp: _cardList[index].updated_at,
                        onDelete: handleCardDelete,
                        onStar: handleCardCollect,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // clear all button
          ElevatedButton(
            onPressed: () {
              print('clear all');
              DatabaseHelper().clearCardTypes().then((value) {
                print('clearCardTypes() called');
                print(value);
                setState(() {
                  _cardList.clear();
                });
              });
            },
            child: const Text('Clear All'),
          ),
          // deleteAllTables
          ElevatedButton(
            onPressed: () {
              print('delete all tables');
              DatabaseHelper().deleteAllTables().then((value) {
                print('deleteAllTables() called');
              });
            },
            child: const Text('Delete All Tables'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CardType newCard = CardType(
            id: 0,
            title: DateTime.now().toString().substring(0, 10), // TODO: 日期格式化
            contentList: [],
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
    );
  }
}
