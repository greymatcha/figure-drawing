import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/pages/select_session.dart';
import 'package:figure_drawing/utilities/session_management.dart';

class HomeTabSessionWidget extends StatefulWidget {
  final bool hasSelectedFolders;
  final List<String> imagePaths;
  final String folderName;
  final VoidCallback selectImages;
  final Function(int?, classes.Session?) startSession;

  const HomeTabSessionWidget(
      this.hasSelectedFolders,
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
  bool hasLoadedSessionStorageDataFile = false;
  classes.Session? session;

  Future<void> navigateSelectSessionPage(BuildContext context) async {
    final classes.Session? resultSession = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SelectSessionPage())
    );

    if (resultSession != null) {
      setState(() {
        session = resultSession;
      });
    }
  }

  void doLoadSessionStorageData() async {
    classes.SessionStorageData savedSessionStorageData = await loadSessionStorageDataJson();
    setState(() {
      hasLoadedSessionStorageDataFile = true;
      if (savedSessionStorageData.lastActive != null) {
        for (classes.Session savedSession in savedSessionStorageData.sessions) {
          if (savedSession.id == savedSessionStorageData.lastActive) {
            session = savedSession;
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    doLoadSessionStorageData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          children: [
            const SizedBox(height: 24),
            widget.hasSelectedFolders ?
            Text('Found ${widget.imagePaths.length.toString()} images in "${widget.folderName}"') :
            const Text("Supported image types: jpg, png, webp, gif"),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: widget.selectImages,
                child: Text((() {
                  if (widget.hasSelectedFolders) {
                    return 'Select a different folder';
                  } else {
                    return 'Select a folder';
                  }
                }()))
            ),
            const SizedBox(height: 24),
            session != null ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(session!.title),
                ]
            ) : const SizedBox(),
            ElevatedButton(
                onPressed: () {
                  navigateSelectSessionPage(context);
                },
                child: const Text("Select session")
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                ElevatedButton(
                  child: const Text("Start"),
                  onPressed: () {
                    widget.startSession(null, session);
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