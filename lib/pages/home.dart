import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:figure_drawing/pages/display.dart';
import 'package:figure_drawing/pages/session_item.dart';
import 'package:figure_drawing/utilities.dart' as utilities;
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
  classes.Session session = classes.Session(
    UniqueKey().toString(),
    "My first session",
    [
      classes.SessionItemComplete(const Key("0"), classes.SessionItemType.draw, 12, 12),
      classes.SessionItemComplete(const Key("1"), classes.SessionItemType.draw, 5, 5),
      classes.SessionItemComplete(const Key("2"), classes.SessionItemType.pause, 120, 0),
      classes.SessionItemComplete(const Key("3"), classes.SessionItemType.draw, 8, 8)
    ]
  );
  int sessionKey = 4; // Should be more than session.length

  void selectImages() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        imagePaths = utilities.getImagesInDirectoryRecursive(selectedDirectory);
        folderName = selectedDirectory;
        if (imagePaths.isNotEmpty) {
          hasSelected = true;
        }
      });
    }
  }

  void showNoFolderSelectedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a folder with images"))
    );
  }

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
              Column(
                children: <Widget>[
                  const SizedBox(height: 24),
                  hasSelected ?
                    Text('Found ${imagePaths.length.toString()} images in "$folderName"') :
                    const Text("Supported image types: jpg, png, webp, gif"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: selectImages,
                    child: Text((() {
                      if (hasSelected) {
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
                                  session: classes.Session(
                                    UniqueKey().toString(),
                                    "Empty session",
                                    [
                                      // Session item for infinite drawings
                                      // with user specified timer value
                                      classes.SessionItemComplete(
                                          const Key("1"),
                                          classes.SessionItemType.draw,
                                          timerValue,
                                          -1
                                      )
                                    ]
                                  ),
                                )),
                              );
                            } else {
                              showNoFolderSelectedMessage();
                            }
                          }
                      )
                    ],
                  )
                ],
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    hasSelected ?
                    Text('Found ${imagePaths.length.toString()} images in "$folderName"') :
                    const Text("Supported image types: jpg, png, webp, gif"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: selectImages,
                      child: Text((() {
                        if (hasSelected) {
                          return 'Select a different folder';
                        } else {
                          return 'Select a folder';
                        }
                      }()))
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ReorderableListView(
                        header: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Create a session"),
                            ElevatedButton(
                                onPressed: () {
                                  _navigateAddEditPage(
                                      context,
                                      classes.SessionItemEdit(
                                          Key((sessionKey + 1).toString()),
                                          classes.SessionItemType.draw,
                                          null,
                                          null
                                      ),
                                      null
                                  );
                                  setState(() {
                                    sessionKey += 1;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
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

                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        footer: Column(
                          children: [
                            const SizedBox(height: 12),
                            ElevatedButton(
                              child: const Text("Start"),
                              onPressed: () {
                                if (!hasSelected) {
                                  showNoFolderSelectedMessage();
                                  return;
                                }
                                if (session.items.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DisplayPage(
                                      imagePaths: imagePaths,
                                      session: session,
                                    )),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        children:
                          session.items.asMap().entries.map((MapEntry entry) {
                            int index = entry.key;
                            classes.SessionItemComplete sessionItem = entry.value;
                            return ListTile(
                              key: sessionItem.key,
                              title: Text(sessionItemDescription(sessionItem)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(onPressed: () {
                                    _navigateAddEditPage(
                                        context,
                                        sessionItem,
                                        index
                                    );
                                  }, icon: const Icon(Icons.edit)),
                                  IconButton(onPressed: () {
                                    setState(() {
                                      session.items.removeAt(index);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Session item removed"))
                                    );
                                  }, icon: const Icon(Icons.delete_outline)),
                                  const SizedBox(width: 32),
                                ],
                              )
                            );
                          }).toList(),
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final classes.SessionItemComplete sessionItem = session.items.removeAt(oldIndex);
                            session.items.insert(newIndex, sessionItem);
                          });
                        }
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

  Future<void> _navigateAddEditPage(BuildContext context, classes.SessionItem sessionItem, int? existingIndex) async {
    final classes.SessionItemComplete? resultSessionItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SessionItemPage(
          sessionItem: sessionItem.runtimeType == classes.SessionItemComplete ? classes.SessionItemEdit(
            sessionItem.key,
            sessionItem.type,
            (sessionItem as classes.SessionItemComplete).timeAmount,
            sessionItem.imageAmount
          ) : sessionItem as classes.SessionItemEdit
      ))
    );
    if (resultSessionItem != null) {
      setState(() {
        if (existingIndex != null) {
          session.items[existingIndex] = resultSessionItem;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Session item updated"))
          );
        } else {
          session.items.add(resultSessionItem);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Session item added"))
          );
        }
      });
    }
  }
}

String sessionItemDescription(classes.SessionItemComplete sessionItem) {
  String result = "";

  if (sessionItem.type == classes.SessionItemType.pause) {
    result = "${sessionItem.timeAmount}s break";
  } else {
    result = "${sessionItem.imageAmount} drawings of ${sessionItem.timeAmount}s each";
  }

  return result;
}
