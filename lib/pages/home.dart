import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:figure_drawing/pages/display.dart';
import 'package:figure_drawing/utilities/utilities.dart' as utilities;
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imagePaths = [];
  String folderName = "";
  bool hasSelected = false;

  int timerValue = 30;
  List<Object> sessionData = [
    {
      "key": "dawdaw",
      "type": "break",
      "isBreak": false,
      "imageAmount": 10,
      "timePerImage": 30
    }
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Figure drawing'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Simple")
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Session")
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    hasSelected ?
                    Text('Found ${imagePaths.length.toString()} images in "$folderName"') :
                    const Text("Supported image types: jpg, png, webp, gif"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: Text((() {
                        if (hasSelected) {
                          return 'Select a different folder';
                        } else {
                          return 'Select a folder';
                        }
                      }())),
                      onPressed: () async {
                        String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                        if (selectedDirectory != null) {
                          setState(() {
                            imagePaths = utilities.getImagesInDirectoryRecursive(selectedDirectory);
                            folderName = selectedDirectory;
                            hasSelected = true;
                          });
                        }
                      },
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
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 10),
                        ElevatedButton(
                            child: const Text('Start'),
                            onPressed: () {
                              if (hasSelected) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DisplayPage(
                                    imagePaths: imagePaths,
                                    userSettings: classes.UserSettings(timerValue),
                                  )),
                                );
                              }
                            }
                        )
                      ],
                    )
                  ],
                )
            ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Expanded(
                      child: ReorderableListView(
                        header: const Text("Create a session"),
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        footer: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                maximumSize: const Size(120, 500),
                                padding: EdgeInsets.fromLTRB(4, 18, 4, 18),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add),
                                  SizedBox(width: 4),
                                  Text("Add item")
                                ],
                              )
                            ),
                          ],
                        ),
                        children: [
                          ListTile(
                            key: Key("1"),
                            title: Text("hi"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                                IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline)),
                                SizedBox(width: 32),
                              ],
                            )
                          )
                        ],
                        onReorder: (int oldIndex, int newIndex) {}
                      )
                    ),
                  ]
                ),
              )
          ]
        )
      )
    );
  }
}
