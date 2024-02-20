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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
        const ContentList(id: '1', content: 'content 1'),
        const ContentList(id: '2', content: 'content 2'),
        const ContentList(id: '3', content: 'content 3'),
      ],
      id: '1',
    ),
    CardType(
      title: 'Card 2',
      // description: 'This is a card',
      contentList: [
        const ContentList(id: '4', content: 'content 4'),
        const ContentList(id: '5', content: 'content 5'),
        const ContentList(id: '6', content: 'content 6'),
      ],
      id: '2',
    ),
    CardType(
      title: 'Card 3',
      // description: 'This is a card',
      contentList: [
        const ContentList(id: '7', content: 'content 7'),
        const ContentList(id: '8', content: 'content 8'),
        const ContentList(id: '9', content: 'content 9'),
      ],
      id: '3',
    ),
  ];

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('main app builded'); // 从路由返回不触发

    const double minCardWidth = 200;

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const DetailsPage(id: '100');
              }));
            }, child: const Text('Go to Second Page'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () {
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
