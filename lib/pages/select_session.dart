import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;

class SelectSessionPage extends StatefulWidget {
  const SelectSessionPage({super.key});

  @override
  State<SelectSessionPage> createState() => _SelectSessionPage();
}

class _SelectSessionPage extends State<SelectSessionPage> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select session")
      ),
      body: Center(
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                print("test");
              },
              child: Container(
                height: 50,
                color: Colors.amber[colorCodes[index]],
                child: Center(child: Text('Entry ${entries[index]}')),
              )
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      )
    );
  }
}
