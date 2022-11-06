import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async' as async;

import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/widgets/display/progress_indicator.dart';

class MenuState {
  bool fileInfo;
  bool showGrid;
  bool flipImage;
  bool blackWhite;
  bool showProgress;

  MenuState(this.fileInfo, this.showGrid, this.flipImage, this.blackWhite, this.showProgress);
}
enum MenuItems { fileInfo, showGrid, flipImage, blackWhite, showProgress }

class DisplayPage extends StatefulWidget {
  final List<String> imagePaths;
  final classes.Session session;

  const DisplayPage({
    super.key,
    required this.imagePaths,
    required this.session
  });

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  int _currentImageIndex = 0;
  int _imageIndexPreviousSessions = 0;
  late int _start = widget.session.items[0].timeAmount;
  int _currentSessionItemIndex = 0;
  bool isPaused = false;
  late bool _inBreak = (widget.session.items[0].type == classes.SessionItemType.pause) ? true : false;

  final classes.TimerController timerController = classes.TimerController();

  final MenuState _menuState = MenuState(false, false, false, false, true);

  bool canGoToNextSession() {
    if (_currentSessionItemIndex < widget.session.items.length - 1) {
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
    classes.SessionItemComplete previousSessionItem = widget.session.items[_currentSessionItemIndex];
    _currentSessionItemIndex += 1;
    _start = currentSessionTimeAmount();
    _inBreak = (widget.session.items[_currentSessionItemIndex].type == classes.SessionItemType.pause) ? true : false;
    _imageIndexPreviousSessions += previousSessionItem.imageAmount;
  }

  // Should only be called inside of setState()
  void goToPreviousSession() {
    _currentSessionItemIndex -= 1;
    _start = currentSessionTimeAmount();
    _inBreak = (widget.session.items[_currentSessionItemIndex].type == classes.SessionItemType.pause) ? true : false;
    _imageIndexPreviousSessions -= widget.session.items[_currentSessionItemIndex].imageAmount;
  }

  int currentSessionTimeAmount() {
    return widget.session.items[_currentSessionItemIndex].timeAmount;
  }

  void goToNextImage() {
    if (_currentImageIndex >= widget.imagePaths.length - 1) {
      // TODO: Support case where there are no images left
      return;
    }

    if (
      // -1 image amount means the session goes on forever. This is used in the "simple" mode.
      widget.session.items[_currentSessionItemIndex].imageAmount != -1 &&
      // Check if we need to change session
      (
        widget.session.items[_currentSessionItemIndex].type == classes.SessionItemType.pause ||
        _currentImageIndex - _imageIndexPreviousSessions >= (widget.session.items[_currentSessionItemIndex].imageAmount) - 1
      )
    ) {
      if (canGoToNextSession()) {
        setState(() {
          goToNextSession();
          if (!_inBreak && _currentSessionItemIndex > 1) {
            _currentImageIndex += 1;
          }
        });
        timerController.reset(widget.session.items[_currentSessionItemIndex].timeAmount);
      } else {
        // TODO: Handle case where we have ended the last session
      }
    // We are in the middle of a drawing session, go to the next image like normal
    } else {
      setState(() {
        _currentImageIndex += 1;
        _start = currentSessionTimeAmount();
      });
      timerController.reset(widget.session.items[_currentSessionItemIndex].timeAmount);
    }
  }

  void goToPreviousImage() {
    if (_currentImageIndex <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("This is the first image"))
      );
      return;
    }

    if (
      widget.session.items[_currentSessionItemIndex].type == classes.SessionItemType.pause ||
      _currentImageIndex - _imageIndexPreviousSessions <= 0
    ) {
      if (canGoToPreviousSession()) {
        setState(() {
          if (!_inBreak) {
            _currentImageIndex -= 1;
          }
          goToPreviousSession();
        });
        timerController.reset(widget.session.items[_currentSessionItemIndex].timeAmount);
      }
    } else {
      setState(() {
        _currentImageIndex -= 1;
        _start = currentSessionTimeAmount();
      });
      timerController.reset(widget.session.items[_currentSessionItemIndex].timeAmount);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timerController.reset(widget.session.items[0].timeAmount);
    });
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
                    _menuState.showGrid = !_menuState.showGrid;
                  }
                  break;

                  case MenuItems.flipImage: {
                    _menuState.flipImage = !_menuState.flipImage;
                  }
                  break;

                  case MenuItems.blackWhite: {
                    _menuState.blackWhite = !_menuState.blackWhite;
                  }
                  break;

                  case MenuItems.showProgress: {
                    _menuState.showProgress = !_menuState.showProgress;
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
                      _menuState.flipImage ?
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
                      _menuState.blackWhite ?
                      const Icon(
                          Icons.check,
                          color: Colors.black
                      ) :
                      const SizedBox.shrink(),
                    ],
                  )
              ),
              PopupMenuItem<MenuItems>(
                  value: MenuItems.showProgress,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Show progress'),
                      _menuState.showProgress ?
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
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Transform.scale(
                                scaleX: _menuState.flipImage ? -1 : 1,
                                child: ColorFiltered(
                                    colorFilter:
                                    ColorFilter.mode(
                                        _menuState.blackWhite ? Colors.grey : Colors.transparent,
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
                    _menuState.showProgress ?
                      ProgressIndicatorWidget(() {
                        if (_currentImageIndex < widget.imagePaths.length - 1) {
                          goToNextImage();
                        }
                      }, timerController) : const SizedBox(),
                  ],
                ),
            ),
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isPaused) {
            timerController.play();
          } else {
            timerController.pause();
          }

          setState(() {
            isPaused = !isPaused;
          });
        },
        child: Icon(
          isPaused ? Icons.play_arrow : Icons.pause,
          size: 25.0,
        ),
      ),
    );
  }
}
