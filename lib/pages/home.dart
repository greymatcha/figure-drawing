import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:figure_drawing/pages/display.dart';
import 'package:figure_drawing/utilities/utilities.dart' as utilities;

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
        title: const Text('Figure drawing'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Select images'),
          onPressed: () async {
            String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
            if (selectedDirectory != null) {
              List <String> imagePaths = utilities.getImagesInDirectoryRecursive(selectedDirectory);

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


