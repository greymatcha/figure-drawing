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
  final List<classes.SessionItem> session;

  const DisplayPage({
    required this.imagePaths,
    required this.session
  });

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  int _currentImageIndex = 0;
  int _imageIndexPreviousSessions = 0;
  int _start = 0;
  bool _timerIsPaused = true;
  bool _inBreak = false;
  int _currentSessionItemIndex = 0;
  async.Timer? _timer;

  MenuState menuState = MenuState(false, false, false, false, true);

  void startTimer() {
    // Prevent multiple timers being created
    if (!_timerIsPaused) {
      return;
    }

    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    setState(() {
      _timerIsPaused = false;
    });
    _timer = async.Timer.periodic(
      const Duration(seconds: 1),
      (async.Timer timer) {
        if (_start == 0) {
          if (_currentImageIndex < widget.imagePaths.length - 1) {
            goToNextImage();
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
      _timerIsPaused = true;
      _timer?.cancel();
    });
  }

  bool canGoToNextSession() {
    if (_currentSessionItemIndex < widget.session.length - 1) {
      return true;
    }

    return false;
  }

  bool canGoToPreviousSession() {
    if (_currentSessionItemIndex <= 0) {
      return false;
    }

    return true;
  }

  // Should only be called inside of setState()
  void goToNextSession() {
    classes.SessionItem previousSessionItem = widget.session[_currentSessionItemIndex];
    _currentSessionItemIndex += 1;
    _start = currentSessionTimeAmount();
    if (widget.session[_currentSessionItemIndex].type == classes.SessionItemType.pause) {
      _inBreak = true;
    } else {
      // TODO: Make breaks also have "0" imageAmount instead of null
      _inBreak = false;
    }

    if (previousSessionItem.type != classes.SessionItemType.pause) {
      _imageIndexPreviousSessions += (previousSessionItem.imageAmount as int);
    }
  }

  void goToPreviousSession() {
    _currentSessionItemIndex -= 1;
    _start = currentSessionTimeAmount();
    if (widget.session[_currentSessionItemIndex].type == classes.SessionItemType.pause) {
      _inBreak = true;
    } else {
      _imageIndexPreviousSessions -= (widget.session[_currentSessionItemIndex].imageAmount as int);
      _inBreak = false;
    }
  }

  int currentSessionTimeAmount() {
    return (widget.session[_currentSessionItemIndex].timeAmount as int);
  }

  void goToNextImage() {
    if (_currentImageIndex >= widget.imagePaths.length - 1) {
      // TODO: Support case where there are no images left
      return;
    }

    if (
      // -1 image amount means the session goes on forever. This is used in the "simple" mode.
      widget.session[_currentSessionItemIndex].imageAmount != -1 &&
      // Check if we need to change session
      (
        widget.session[_currentSessionItemIndex].type == classes.SessionItemType.pause ||
        _currentImageIndex - _imageIndexPreviousSessions >= (widget.session[_currentSessionItemIndex].imageAmount as int) - 1
      )
    ) {
      if (canGoToNextSession()) {
        setState(() {
          goToNextSession();
          if (!_inBreak) {
            _currentImageIndex += 1;
          }
        });
        startTimer();
      } else {
        // TODO: Handle case where we have ended the last session
      }
    // We are in the middle of a drawing session, go to the next image like normal
    } else {
      setState(() {
        _currentImageIndex += 1;
        _start = currentSessionTimeAmount();
      });
      startTimer();
    }

    print("_imageIndexPreviousSessions ${_imageIndexPreviousSessions}");
    print("CURRENT SESSION: ${_currentSessionItemIndex}");
  }

  void goToPreviousImage() {
    if (_currentImageIndex <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("This is the first image"))
      );
      return;
    }

    if (
      widget.session[_currentSessionItemIndex].type == classes.SessionItemType.pause ||
      _currentImageIndex - _imageIndexPreviousSessions < (widget.session[_currentSessionItemIndex].imageAmount as int) - 1
    ) {
      if (canGoToPreviousSession()) {
        setState(() {
          if (!_inBreak) {
            _currentImageIndex -= 1;
          }
          goToPreviousSession();
        });
        startTimer();
      }
    } else {
      setState(() {
        _currentImageIndex -= 1;
        _start = currentSessionTimeAmount();
      });
      startTimer();
    }

    print("_imageIndexPreviousSessions ${_imageIndexPreviousSessions}");
    print("CURRENT SESSION: ${_currentSessionItemIndex}");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _start = widget.session[_currentSessionItemIndex].timeAmount as int;
      });
      startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
                        Expanded(
                          child: Transform.scale(
                              scaleX: menuState.flipImage ? -1 : 1,
                              child: ColorFiltered(
                                  colorFilter:
                                  ColorFilter.mode(
                                      menuState.blackWhite ? Colors.grey : Colors.transparent,
                                      BlendMode.saturation
                                  ),
                                  child: _inBreak ? const Text("BREAK") : Image.file(
                                    io.File(widget.imagePaths[_currentImageIndex]),
                                    fit: BoxFit.contain,
                                  )
                              )
                          ),
                        )
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
                                goToPreviousImage();
                              } else {
                                goToNextImage();
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
          _timerIsPaused ? startTimer() : pauseTimer();
        },
        child: Icon(
          _timerIsPaused ? Icons.play_arrow : Icons.pause,
          size: 25.0,
        ),
      ),
    );
  }
}
