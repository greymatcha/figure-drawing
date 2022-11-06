import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/widgets/home/folder_select.dart';

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
  final Function(int?, classes.Session?) startSession;
  final classes.FolderSelectController folderSelectController;

  const HomeTabSimpleWidget(
      this.startSession,
      this.folderSelectController,
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
        FolderSelectWidget(widget.folderSelectController),
        const SizedBox(height: 12),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Time per image'),
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
