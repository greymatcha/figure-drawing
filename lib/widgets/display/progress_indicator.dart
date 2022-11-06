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
  int durationAmount = 0;

  _ProgressIndicatorWidget(classes.TimerController timerController) {
    timerController.pause = pause;
    timerController.play = play;
    timerController.reset = reset;
  }

  void reset(int newDurationAmount) {
    setState(() {
      if (controller != null) {
        controller!.dispose();
      }
      controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: newDurationAmount),
      )..addListener(() {
        setState(() {});
      });

      durationAmount = newDurationAmount;
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
    Duration? timer;
    String timerText = "";
    if (controller != null) {
      timer = Duration(seconds: (controller!.value * durationAmount).toInt());
      String minutes = (Duration(seconds: durationAmount).inMinutes - timer.inMinutes.remainder(durationAmount)).toString().padLeft(2, "0");
      String seconds = ((durationAmount - timer.inSeconds.remainder(durationAmount)) % 60).toString().padLeft(2, "0");
      timerText = '$minutes:$seconds';
    }


    return controller != null ? Row(
      children: [
        Expanded(child: LinearProgressIndicator(
          value: controller!.value,
          semanticsLabel: 'Linear progress indicator',
        )),
        Text(
          timerText,
          style: TextStyle(
            color: Colors.white,
          ),
        )
      ],
    ) : const SizedBox();
  }
}
