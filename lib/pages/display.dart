import 'package:flutter/material.dart';
import 'dart:io' as io;

class DisplayPage extends StatefulWidget {
  final List<String> imagePaths;

  const DisplayPage({ required this.imagePaths });

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Figure drawing')
      ),
      body: Center(
        child: Column (
          children: <Widget>[
            Expanded(
              child:  Image.file(
                io.File(widget.imagePaths[currentIndex]),
                fit: BoxFit.contain,
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: const Text("Previous"),
                    onPressed: () {
                      if (currentIndex > 0) {
                        setState(() {
                          currentIndex -= 1;
                        });
                      }
                    }
                ),
                ElevatedButton(
                    child: const Text("Next"),
                    onPressed: () {
                      if (currentIndex < widget.imagePaths.length - 1) {
                        setState(() {
                          currentIndex += 1;
                        });
                      }
                    }
                ),
              ],
            )
          ]
        )
      )
    );
  }
}
