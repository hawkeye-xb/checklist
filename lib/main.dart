import 'dart:ffi';

import 'package:checklist/details.dart';
import 'package:flutter/material.dart';
import 'package:checklist/components/card.dart';

class CardType {
  final String title;
  // final String description;
  final List<ContentList> contentList;
  final String id;

  CardType({
    required this.title,
    // this.description = '',
    this.contentList = const [],
    required this.id
  });
}

void main() {
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
  // mock data
  final List<CardType> _cardList = [
    CardType(
      title: 'Card 1',
      // description: 'This is a card',
      contentList: [
        const ContentList(id: '1', content: '车厘子', checked: true),
        const ContentList(id: '2', content: '刮胡刀'),
        const ContentList(id: '3', content: '手机充电器 * 2', checked: true),
      ],
      id: '1',
    ),
    CardType(
      title: 'Card 2',
      // description: 'This is a card',
      contentList: [
        const ContentList(id: '4', content: '手机、电脑、手表、iPad充电器'),
        const ContentList(id: '5', content: 'contentbNSDCNSs'),
        const ContentList(id: '6', content: 'contents:sjhcaycbNSDCNSs'),
      ],
      id: '2',
    ),
    CardType(
      title: 'Card 3',
      // description: 'This is a card',
      contentList: [
        const ContentList(id: '7', content: 'caycbNSDCNSs'),
        const ContentList(id: '8', content: 'coents:sjhcaycbNSDCNSs'),
        const ContentList(id: '9', content: 'contecbNSDCNSs'),
      ],
      id: '3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    print('main app builded'); // 从路由返回不触发

    const double minCardWidth = 200;

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
                    child: CardWidget(
                      id: _cardList[index].id,
                      title: _cardList[index].title,
                      firstThreeItems: _cardList[index].contentList,
                    ),
                  );
                },
              ),
            ),
          ),
          const Text(
            'You have pushed the button this many times:',
          ),
          // TODO: Remove
          TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const DetailsPage(id: '100');
            }));
          }, child: const Text('Go to Second Page')),
        ],
      ),
    );
  }
}
