import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:figure_drawing/classes.dart' as classes;

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

Future<classes.SessionStorageData> loadSessionStorageDataJson() async {

  File sessionStorageDataFile = await getSessionStorageDataFile;

  String sessionStorageDataFileString = await sessionStorageDataFile.readAsString();

  if (sessionStorageDataFileString.isEmpty) {
    classes.SessionStorageData newSessionStorageData = classes.SessionStorageData(
        [],
        null
    );
    saveSessionStorageDataJsonToDisk(newSessionStorageData);
    return newSessionStorageData;
  }
  Map <String, dynamic> jsonDecoded = json.decode(sessionStorageDataFileString);
  return classes.SessionStorageData.fromJson(
      jsonDecoded
  );

}
