import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:figure_drawing/pages/home/display.dart';
import 'package:figure_drawing/utilities/image_loading.dart';
import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/widgets/home/tab_simple.dart';
import 'package:figure_drawing/widgets/home/tab_session.dart';

class HomePage extends StatefulWidget {
  const HomePage ({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imagePaths = [];
  String folderName = "";
  bool hasSelectedFolders = false;

  void selectImages() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        imagePaths = getImagesInDirectoryRecursive(selectedDirectory);
        folderName = selectedDirectory;
        if (imagePaths.isNotEmpty) {
          hasSelectedFolders = true;
        }
      });
    }
  }

  void startSession(int? timerValue, classes.Session? session) {
    if (hasSelectedFolders) {
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
      } else if (session != null) {
        sessionToUse = session;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a session"))
        );
        return;
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                child: HomeTabSimpleWidget(
                    hasSelectedFolders,
                    imagePaths,
                    folderName,
                    selectImages,
                    startSession,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                child: HomeTabSessionWidget(
                    hasSelectedFolders,
                    imagePaths,
                    folderName,
                    selectImages,
                    startSession
                ),
              )
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
