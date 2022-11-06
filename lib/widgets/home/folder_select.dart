import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/utilities/image_loading.dart';

class FolderSelectWidget extends StatefulWidget {
  final classes.FolderSelectController folderSelectController;

  const FolderSelectWidget(
      this.folderSelectController,
      { super.key }
    );

  @override
  State<FolderSelectWidget> createState() => _FolderSelectWidget();
}

List<Map<String, Object>> sortDropdownOptions = [
  { "label": "Random", "value": "random" },
  { "label": "Alphabetical (asc)", "value": "alphabetical_ascending" },
  { "label": "Alphabetical (desc)", "value": "alphabetical_descending" },
];

class _FolderSelectWidget extends State<FolderSelectWidget> {
  bool hasSelectedFolders = false;
  String folderName = "";
  String sortValue = "random";
  Map<String, List<String>> selectedFolders = {};

  void addFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null && !selectedFolders.containsKey(selectedDirectory)) {
      List<String> imagesInFolder = getImagesInDirectoryRecursive(selectedDirectory);
      setState(() {
        selectedFolders[selectedDirectory] = imagesInFolder;
      });
    }
  }

  List<String> getImagePaths() {
    List<String> result = [];
    selectedFolders.forEach((folderName, imagePaths) {
      for (String imagePath in imagePaths) {
        if (!result.contains(imagePath)) {
          result.add(imagePath);
        }
      }
    });

    switch (sortValue) {
      case "random":
        result.shuffle();
        break;
      case "alphabetical_ascending":
        result.sort();
        break;
      case "alphabetical_descending":
        result.sort();
        result = result.reversed.toList();
        break;
    }

    return result;
  }

  List<Widget> getFolderRows() {
    List<Widget> result = [];
    selectedFolders.forEach((key, value) {
      result.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(key, overflow: TextOverflow.ellipsis)
            ),
            Row(
              children: [
                Text("${value.length.toString()} image${value.length > 1 ? "s" : ""}" ),
                const SizedBox(width: 4),
                IconButton(
                    onPressed: () {
                      setState(() {
                        selectedFolders.remove(key);
                      });
                    },
                    icon: const Icon(Icons.clear),
                  tooltip: "Remove folder",
                )
              ],
            )
          ],
        )
      );
    });
    return result;
  }

  @override
  void initState() {
    super.initState();
    widget.folderSelectController.getImagePaths = getImagePaths;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selectedFolders.keys.isNotEmpty ?
              Text('Found ${getImagePaths().length} image(s) in ${selectedFolders.keys.length} folder(s)') :
              const Text("Supported image types: jpg, png, webp, gif"),
            IconButton(
              onPressed: addFolder,
              icon: const Icon(Icons.add),
              tooltip: "Add folder",
            )
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10)
          ),
          child: getImagePaths().isNotEmpty ?
            Column(
              children: getFolderRows(),
            ) : const Center(
                child: Text("No folders selected"),
            ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Sort images"),
            DropdownButton(
              value: sortValue,
              // isExpanded:true,
              items: sortDropdownOptions.map((Map item) {
                return DropdownMenuItem(
                  value: item["value"],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item["label"]),
                    ],
                  ),

                );
              }).toList(),
              onChanged: (Object? selectedItem) {
                setState(() {
                  sortValue = selectedItem as String;
                });
              }
            )
          ],
        )
      ]
    );
  }
}

