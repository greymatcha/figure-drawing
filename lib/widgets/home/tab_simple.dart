import 'package:flutter/material.dart';

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
  final bool hasSelected;
  final List<String> imagePaths;
  final String folderName;
  final VoidCallback selectImages;
  final Function(int?) startSession;

  const HomeTabSimpleWidget(
      this.hasSelected,
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
        Expanded(
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
                    }())),
                  ),
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
                ]
            )
        ),

        Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                widget.startSession(timerValue);
              },
              child: const Text('Start'),
            ),
            const SizedBox(height: 32),
          ],
        )
      ],
    );
  }
}
