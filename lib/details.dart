import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.id});

  final String id;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // String _editedData;

  // @override
  // void initState() {
  //   super.initState();
  //   _editedData = widget.initialData;
  // }

  @override
  Widget build(BuildContext context) {
    print('DetailsPage build() called');
    print('widget.id: ${widget.id}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Edit Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          onChanged: (newValue) {
            print(newValue);
            // setState(() {
            //   _editedData = newValue;
            // });
          }, 
        ),
      ),
    );
  }
}
