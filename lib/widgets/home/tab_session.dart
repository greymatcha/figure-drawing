import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/pages/select_session.dart';

class HomeTabSessionWidget extends StatefulWidget {
  final bool hasSelected;
  final List<String> imagePaths;
  final String folderName;
  final VoidCallback selectImages;
  final Function(int?) startSession;

  const HomeTabSessionWidget(
      this.hasSelected,
      this.imagePaths,
      this.folderName,
      this.selectImages,
      this.startSession,
      {super.key}
      );

  @override
  State<HomeTabSessionWidget> createState() => _HomeTabSessionWidget();
}

class _HomeTabSessionWidget extends State<HomeTabSessionWidget> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          children: [
            const SizedBox(height: 24),
            widget.hasSelected ?
            Text('Found ${widget.imagePaths.length.toString()} images in "${widget.folderName}"') :
            const Text("Supported image types: jpg, png, webp, gif"),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: widget.selectImages,
                child: Text((() {
                  if (widget.hasSelected) {
                    return 'Select a different folder';
                  } else {
                    return 'Select a folder';
                  }
                }()))
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SelectSessionPage())
                  );
                },
                child: const Text("Select session")
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                ElevatedButton(
                  child: const Text("Start"),
                  onPressed: () {
                    widget.startSession(null);
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ]
      ),
    );
  }
}