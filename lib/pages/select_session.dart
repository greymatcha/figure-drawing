import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/pages/create_session.dart';

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

  Future<File> get getSessionStorageDataFile async {
    Directory documentsDirectory = await path_provider.getApplicationDocumentsDirectory();
    String documentsPath = documentsDirectory.path;
    return File("$documentsPath/FigureDrawing/session_storage_data.json").create(recursive: true);
  }

  void saveSessionStorageDataJsonToDisk(classes.SessionStorageData sessionStorageDataToSave) async {
    File sessionStorageDataFile = await getSessionStorageDataFile;

    if (!await sessionStorageDataFile.exists()) {
      await sessionStorageDataFile.create();
    }
    
    sessionStorageDataFile.writeAsString(
      jsonEncode(sessionStorageDataToSave)
    );
  }

  void loadSessionStorageDataJson() async {
    File sessionStorageDataFile = await getSessionStorageDataFile;

    String sessionStorageDataFileString = await sessionStorageDataFile.readAsString();

    if (sessionStorageDataFileString.isEmpty) {
      classes.SessionStorageData newSessionStorageData = classes.SessionStorageData(
          [],
          null
      );
      saveSessionStorageDataJsonToDisk(newSessionStorageData);
      setState(() {
        sessionStorageData = newSessionStorageData;
      });
    } else {
      Map <String, dynamic> jsonDecoded = json.decode(sessionStorageDataFileString);
      setState(() {
        sessionStorageData = classes.SessionStorageData.fromJson(
          jsonDecoded
        );
      });
    }
    hasLoadedSessionStorageDataFile = true;
  }

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
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Session updated"))
          );
        } else {
          sessionStorageData.sessions.add(resultSession);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Session saved"))
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


  @override
  void initState() {
    super.initState();

    loadSessionStorageDataJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select session")
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hasLoadedSessionStorageDataFile ?
                sessionStorageData.sessions.isEmpty ?
                  const Text("empty") :
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: sessionStorageData.sessions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(sessionStorageData.sessions[index].title),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          navigateAddEditPage(
                                            context,
                                            sessionStorageData.sessions[index],
                                            index
                                          );
                                        },
                                        icon: const Icon(Icons.edit),
                                        iconSize: 18,
                                      ),
                                      const SizedBox(width: 24),
                                      IconButton(
                                        onPressed: () {
                                          deleteSession(index);
                                        },
                                        icon: const Icon(Icons.delete_outline),
                                        iconSize: 18,
                                      ),
                                    ],
                                  )
                                ]
                              )
                            ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    )
                  ) : const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: () {
                  navigateAddEditPage(
                    context,
                    classes.Session(
                      UniqueKey().toString(),
                      "",
                      []
                    ),
                    null
                  );
                },
                child: const Text("Create new session")
              ),
            ],
          )
        )
      )
    );
  }
}
