import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' as io;

import 'package:figure_drawing/pages/display.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Figure Drawing'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Select images'),
          onPressed: () async {
            String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
            if (selectedDirectory != null) {
              List <String> imagePaths = getImagesInDirectoryRecursive(selectedDirectory);

              if (!mounted) return;

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisplayPage(imagePaths: imagePaths)),
              );
            }
          },
        ),
      ),
    );
  }
}

List <String> getImagesInDirectoryRecursive(String directory, {int currentDepth = 0}) {
  List <String> result = [];

  // Safeguard to make sure we don't infinitely search through files
  if (currentDepth > 7) {
    debugPrint("Max search depth reached");
    return result;
  }

  List <io.FileSystemEntity> elementList = io.Directory(directory).listSync();
  for (var i = 0; i < elementList.length; i++) {
    var element = elementList[i];
    if (io.FileSystemEntity.isDirectorySync(element.path)) {
      result = [...result, ...getImagesInDirectoryRecursive(element.path, currentDepth: currentDepth + 1)];
    } else {
      result.add(element.path);
    }
  }
  return result;
}
