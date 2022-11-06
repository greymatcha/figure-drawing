import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;

const List<Map<String, Object>> timerDropdownOptions = [
  { "label": "2s", "value": 2 },
  { "label": "30s", "value": 30 },
  { "label": "45s", "value": 45 },
  { "label": "1m", "value": 60 },
  { "label": "2m", "value": 120 },
  { "label": "5m", "value": 300 },
  { "label": "10m", "value": 600 },
];

class HomeTabSimpleWidget extends StatefulWidget {
  final bool hasSelectedFolders;
  final List<String> imagePaths;
  final String folderName;
  final VoidCallback selectImages;
  final Function(int?, classes.Session?) startSession;

  const HomeTabSimpleWidget(
      this.hasSelectedFolders,
      this.imagePaths,
      this.folderName,
      this.selectImages,
      this.startSession,
      {super.key}
      );

  @override
  State<HomeTabSimpleWidget> createState() => _HomeTabSimpleWidget();
}

class _HomeTabSimpleWidget extends State<HomeTabSimpleWidget> {

  int timerValue = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.hasSelectedFolders ?
        Text('Found ${widget.imagePaths.length.toString()} images in "${widget.folderName}"') :
        const Text("Supported image types: jpg, png, webp, gif"),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: widget.selectImages,
          child: Text((() {
            if (widget.hasSelectedFolders) {
              return 'Select a different folder';
            } else {
              return 'Select a folder';
            }
          }())),
        ),
        const SizedBox(height: 12),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Time per image:'),
              const SizedBox(width: 10),
              DropdownButton(
                value: timerValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                onChanged: (Object? selectedItem) {
                  setState(() {
                    timerValue = selectedItem as int;
                  });
                },
                items: timerDropdownOptions.map((Map item) {
                  return DropdownMenuItem(
                      value: item["value"],
                      child: Text(item["label"])
                  );
                }).toList(),
              ),
            ]
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            widget.startSession(timerValue, null);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50)
          ),
          child: const Text('Start'),
        ),
      ]
    );
  }
}
