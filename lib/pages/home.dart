import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:figure_drawing/pages/display.dart';
import 'package:figure_drawing/pages/create_session_item.dart';
import 'package:figure_drawing/utilities.dart' as utilities;
import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/widgets/home/tab_simple.dart';
import 'package:figure_drawing/widgets/home/tab_session.dart';


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
  const HomePage ({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
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
      classes.SessionItemComplete(classes.SessionItemType.draw, 12, 12),
      classes.SessionItemComplete(classes.SessionItemType.draw, 5, 5),
      classes.SessionItemComplete(classes.SessionItemType.pause, 120, 0),
      classes.SessionItemComplete(classes.SessionItemType.draw, 8, 8)
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

  void startSession(int? timerValue) {
    if (hasSelected) {
      late classes.Session sessionToUse;
      if (timerValue != null) {
        sessionToUse = classes.Session(
            UniqueKey().toString(),
            "Empty session",
            [
              // Session item for infinite drawings
              // with user specified timer value
              classes.SessionItemComplete(
                  classes.SessionItemType.draw,
                  timerValue,
                  -1
              )
            ]
        );
      } else {
        sessionToUse = session;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DisplayPage(
          imagePaths: imagePaths,
          session: sessionToUse,
        )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a folder with images"))
      );
    }
  }

  void setSession(classes.Session newSession) {
    setState(() {
      session = newSession;
    });
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
              HomeTabSimpleWidget(
                hasSelected,
                imagePaths,
                folderName,
                selectImages,
                startSession
              ),
              HomeTabSessionWidget(
                  hasSelected,
                  imagePaths,
                  folderName,
                  selectImages,
                  startSession
              ),
          ]
        )
      )
    );
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
