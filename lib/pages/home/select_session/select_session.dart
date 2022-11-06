import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/pages/home/select_session/create_session.dart';
import 'package:figure_drawing/utilities/session_management.dart';
import 'package:figure_drawing/widgets/home/session_row.dart';

class SelectSessionPage extends StatefulWidget {
  const SelectSessionPage({super.key});

  @override
  State<SelectSessionPage> createState() => _SelectSessionPage();
}

class _SelectSessionPage extends State<SelectSessionPage> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  bool hasLoadedSessionStorageDataFile = false;
  late classes.SessionStorageData sessionStorageData;

  Future<void> navigateAddEditPage(BuildContext context, classes.Session sessionToEdit, int? existingIndex) async {
    final classes.Session? resultSession = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateSessionPage(
            session: sessionToEdit
        ))
    );

    if (resultSession != null) {
      setState(() {
        if (existingIndex != null) {
          sessionStorageData.sessions[existingIndex] = resultSession;
        } else {
          sessionStorageData.sessions.add(resultSession);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Session created"))
          );
        }
      });
      saveSessionStorageDataJsonToDisk(sessionStorageData);
    }
  }

  void deleteSession(int index) {
    classes.Session sessionToDelete = sessionStorageData.sessions[index];

    setState(() {
      sessionStorageData.sessions.removeAt(index);
    });

    saveSessionStorageDataJsonToDisk(sessionStorageData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Session removed"),
        action: SnackBarAction(label: "Undo", onPressed: () {
          setState(() {
            sessionStorageData.sessions.insert(index, sessionToDelete);
          });

          saveSessionStorageDataJsonToDisk(sessionStorageData);
        })
      )
    );
  }

  void selectSession(int index) {
    setState(() {
      sessionStorageData.lastActive = sessionStorageData.sessions[index].id;
    });

    saveSessionStorageDataJsonToDisk(sessionStorageData);

    Navigator.pop(context, sessionStorageData.sessions[index]);
  }

  void doLoadSessionStorageData() async {
    classes.SessionStorageData savedSessionStorageData = await loadSessionStorageDataJson();
    setState(() {
      hasLoadedSessionStorageDataFile = true;
      sessionStorageData = savedSessionStorageData;
    });
  }

  @override
  void initState() {
    super.initState();

    doLoadSessionStorageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select session")
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hasLoadedSessionStorageDataFile ?
                sessionStorageData.sessions.isEmpty ?
                  const Text("No sessions found") :
                  Expanded(
                    child: ListView.separated(
                      itemCount: sessionStorageData.sessions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SessionRow(
                          sessionStorageData.sessions[index],
                          index,
                          (session, index) => {
                            navigateAddEditPage(context, session, index)
                          },
                          deleteSession,
                          () => {
                            selectSession(index)
                          },
                          false
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    )
                  ) : const CircularProgressIndicator(),
            ],
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateAddEditPage(
              context,
              classes.Session(
                  UniqueKey().toString(),
                  "",
                  "",
                  []
              ),
              null
          );
        },
        child: const Icon(
          Icons.add,
          size: 25.0,
        ),
      ),
    );
  }
}
