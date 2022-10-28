import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async' as async;

import 'package:figure_drawing/classes.dart' as classes;

class MenuState {
  bool fileInfo;
  bool showGrid;
  bool flipImage;
  bool blackWhite;
  bool showTimer;

  MenuState(this.fileInfo, this.showGrid, this.flipImage, this.blackWhite, this.showTimer);
}
enum MenuItems { fileInfo, showGrid, flipImage, blackWhite, showTimer }

class DisplayPage extends StatefulWidget {
  final List<String> imagePaths;
  final classes.UserSettings userSettings;

  const DisplayPage({
    required this.imagePaths,
    required this.userSettings
  });

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  int currentIndex = 0;
  late async.Timer _timer;
  int _start = 0;
  bool timerIsPaused = true;

  MenuState menuState = MenuState(false, false, false, false, true);

  void startTimer() {
    // Prevent multiple timers being created
    if (!timerIsPaused) {
      return;
    }

    setState(() {
      timerIsPaused = false;
    });
    const oneSec = Duration(seconds: 1);
    _timer = async.Timer.periodic(
      oneSec,
      (async.Timer timer) {
        if (_start == 0) {
          if (currentIndex < widget.imagePaths.length - 1) {
            setState(() {
              currentIndex += 1;
              _start = widget.userSettings.timeBetweenImages;
            });
          } else {
            setState(() {
              timer.cancel();
            });
          }
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void pauseTimer() {
    setState(() {
      timerIsPaused = true;
      _timer.cancel();
    });
  }

  void previousImage() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex -= 1;
      });
    }
  }

  void nextImage() {
    if (currentIndex < widget.imagePaths.length - 1) {
      setState(() {
        currentIndex += 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _start = widget.userSettings.timeBetweenImages;
      });
      startTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Figure drawing'),
        actions: <Widget> [
          PopupMenuButton<MenuItems>(
            onSelected: (MenuItems item) {
              setState(() {
                switch (item) {
                  case MenuItems.fileInfo: {
                  //  TODO
                  }
                  break;

                  case MenuItems.showGrid: {
                    menuState.showGrid = !menuState.showGrid;
                  }
                  break;

                  case MenuItems.flipImage: {
                    menuState.flipImage = !menuState.flipImage;
                  }
                  break;

                  case MenuItems.blackWhite: {
                    menuState.blackWhite = !menuState.blackWhite;
                  }
                  break;

                  case MenuItems.showTimer: {
                    menuState.showTimer = !menuState.showTimer;
                  }
                  break;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<MenuItems>>[
              PopupMenuItem<MenuItems>(
                  value: MenuItems.flipImage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Flip image'),
                      menuState.flipImage ?
                      const Icon(
                          Icons.check,
                          color: Colors.black
                      ) :
                      const SizedBox.shrink(),
                    ],
                  )
              ),
              PopupMenuItem<MenuItems>(
                  value: MenuItems.blackWhite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Black & white'),
                      menuState.blackWhite ?
                      const Icon(
                          Icons.check,
                          color: Colors.black
                      ) :
                      const SizedBox.shrink(),
                    ],
                  )
              ),
              PopupMenuItem<MenuItems>(
                  value: MenuItems.showTimer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Show timer'),
                      menuState.showTimer ?
                      const Icon(
                          Icons.check,
                          color: Colors.black
                      ) :
                      const SizedBox.shrink(),
                    ],
                  )
              ),
            ]
          ),
        ],
      ),
      body: Center(
        child: Column (
          children: <Widget>[
            Expanded(
                child: Stack(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                            scaleX: menuState.flipImage ? -1 : 1,
                            child: ColorFiltered(
                                colorFilter:
                                ColorFilter.mode(
                                    menuState.blackWhite ? Colors.grey : Colors.transparent,
                                    BlendMode.saturation
                                ),
                                child: Image.file(
                                  io.File(widget.imagePaths[currentIndex]),
                                  fit: BoxFit.contain,
                                )
                            )
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              final RenderBox box = context.findRenderObject() as RenderBox;
                              final localOffset = box.globalToLocal(details.globalPosition);
                              final x = localOffset.dx;
                              if (x < box.size.width / 2) {
                                previousImage();
                              } else {
                                nextImage();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: menuState.showTimer ?
                          Text("$_start") :
                          const SizedBox.shrink(),
                    ),
                  ],
                ),
            ),
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          timerIsPaused ? startTimer() : pauseTimer();
        },
        child: Icon(
          timerIsPaused ? Icons.play_arrow : Icons.pause,
          size: 25.0,
        ),
      ),
    );
  }
}
