import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async' as async;

import 'package:figure_drawing/classes.dart' as classes;

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
        actions: <Widget> [],
      ),
      body: Center(
        child: Column (
          children: <Widget>[
            Expanded(
                child: Stack(
                  children: <Widget>[
                    Image.file(
                      io.File(widget.imagePaths[currentIndex]),
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Text("$_start")
                    )
                  ],
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: const Text("Previous"),
                    onPressed: () {
                      if (currentIndex > 0) {
                        setState(() {
                          currentIndex -= 1;
                        });
                      }
                    }
                ),
                timerIsPaused ?
                  ElevatedButton(
                      child: Text("Continue"),
                      onPressed: () {
                        startTimer();
                      }
                  ) :
                  ElevatedButton(
                      child: Text("Pause"),
                      onPressed: () {
                        pauseTimer();
                      }
                  ),
                ElevatedButton(
                    child: const Text("Next"),
                    onPressed: () {
                      if (currentIndex < widget.imagePaths.length - 1) {
                        setState(() {
                          currentIndex += 1;
                        });
                      }
                    }
                ),
              ],
            )
          ]
        )
      )
    );
  }
}
