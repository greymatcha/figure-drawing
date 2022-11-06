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
    /* Code for if we want to add a countdown timer */
    // Duration? timer;
    // String timerText = "";
    // if (controller != null) {
    //   timer = Duration(seconds: (controller!.value * durationAmount).toInt());
    //   String minutes = (Duration(seconds: durationAmount).inMinutes - timer.inMinutes.remainder(durationAmount)).toString().padLeft(2, "0");
    //   String seconds = ((durationAmount - timer.inSeconds.remainder(durationAmount)) % 60).toString().padLeft(2, "0");
    //   timerText = '$minutes:$seconds';
    // }


    return controller != null ? Column(
      children: [
        /* Code for if we want to add a linear progress indicator */
        // LinearProgressIndicator(
        //   value: controller!.value,
        //   semanticsLabel: 'Linear progress indicator',
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  value: controller!.value,
                  semanticsLabel: 'Image progress',
                  backgroundColor: Colors.grey[800],
                ))
              )
          ],

        ),
        /* Code for if we want to add a countdown timer */
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        //         decoration: BoxDecoration(
        //             color: Colors.grey[800],
        //           borderRadius: BorderRadius.circular(20)
        //         ),
        //         child: Text(
        //           timerText,
        //           style: const TextStyle(
        //             color: Colors.white,
        //           ),
        //         ),
        //       )
        //     )
        //
        //   ],
        // )
      ],
    ) : const SizedBox();
  }
}
