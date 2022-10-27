import 'dart:io' as io;
import 'package:mime/mime.dart' as mime;

const List<String> supportedMimetypes = [
  "image/webp",
  "image/jpeg",
  "image/png",
  "image/bmp",
  "image/gif"
];

List <String> getImagesInDirectoryRecursive(String directory, {int currentDepth = 0}) {
  List <String> result = [];

  // Safeguard to make sure we don't infinitely search through files
  if (currentDepth > 7) {
    return result;
  }

  List <io.FileSystemEntity> elementList = io.Directory(directory).listSync();
  for (var i = 0; i < elementList.length; i++) {
    var element = elementList[i];
    if (io.FileSystemEntity.isDirectorySync(element.path)) {
      result = [...result, ...getImagesInDirectoryRecursive(element.path, currentDepth: currentDepth + 1)];
    } else {
      String? mimeType = mime.lookupMimeType(element.path);
      if (mimeType != null) {
        if (supportedMimetypes.contains(mimeType)) {
          result.add(element.path);
        }
      }
    }
  }
  return result;
}