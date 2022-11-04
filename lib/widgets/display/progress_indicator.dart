import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;

class ProgressIndicatorWidget extends StatefulWidget {
  final Function onFinished;

final classes.TimerController timerController;

  const ProgressIndicatorWidget(
      this.onFinished,
      this.timerController,
      { super.key }
    );

  @override
  State<ProgressIndicatorWidget> createState() => _ProgressIndicatorWidget(timerController);
}

class _ProgressIndicatorWidget extends State<ProgressIndicatorWidget> with TickerProviderStateMixin {
  AnimationController? controller;

  _ProgressIndicatorWidget(classes.TimerController timerController) {
    timerController.pause = pause;
    timerController.play = play;
    timerController.reset = reset;
  }

  void reset(int durationAmount) {
    setState(() {
      if (controller != null) {
        controller!.dispose();
      }
      controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: durationAmount),
      )..addListener(() {
        setState(() {});
      });
    });
    play();
  }

  void pause() {
    setState(() {
      controller!.stop();
    });

  }

  void play() {
    setState(() {
      controller!.forward().then((value) {
        print("lol");
        widget.onFinished();
      });
    });

  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return controller != null ? LinearProgressIndicator(
      value: controller!.value,
      semanticsLabel: 'Linear progress indicator',
    ) : const SizedBox();
  }
}
