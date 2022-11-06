import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/pages/home/select_session/select_session.dart';
import 'package:figure_drawing/utilities/session_management.dart';
import 'package:figure_drawing/widgets/home/session_row.dart';
import 'package:figure_drawing/widgets/home/folder_select.dart';

class HomeTabSessionWidget extends StatefulWidget {
  final Function(int?, classes.Session?) startSession;
  final classes.FolderSelectController folderSelectController;

  const HomeTabSessionWidget(
      this.startSession,
      this.folderSelectController,
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
    classes.Session? lastActiveSession;
    if (savedSessionStorageData.lastActive != null) {
      for (classes.Session savedSession in savedSessionStorageData.sessions) {
        if (savedSession.id == savedSessionStorageData.lastActive) {
          lastActiveSession = savedSession;
          break;
        }
      }
    }

    setState(() {
      hasLoadedSessionStorageDataFile = true;
      if (lastActiveSession != null) {
        session = lastActiveSession;
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
          FolderSelectWidget(widget.folderSelectController),
          const SizedBox(height: 24),

          Row(
            children: const [
              Text("Session")
            ]
          ),
          const SizedBox(height: 8),
          session != null ? SessionRow(session!, 1, null, null,
              () => {
                navigateSelectSessionPage(context)
              }, true
            ) : SessionRow(
            classes.Session("1", "Select a session", []),
              1, null, null,
                  () => {
                navigateSelectSessionPage(context)
              }, true
            ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              widget.startSession(null, session);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50)
            ),
            child: const Text("Start"),
          ),
        ]
      ),
    );
  }
}