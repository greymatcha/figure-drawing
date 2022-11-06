import 'package:flutter/material.dart';

import 'package:figure_drawing/pages/home/home.dart';
import 'package:figure_drawing/classes.dart' as classes;

class SessionEndPage extends StatelessWidget {
  final bool sessionEnded;
  final List<String> imagePaths;
  final classes.Session session;
  final int imageIndex;
  final int sessionIndex;

  const SessionEndPage(
      this.sessionEnded,
      this.imagePaths,
      this.session,
      this.imageIndex,
      this.sessionIndex,
      { super.key }
    );

  List<String> getSessionLength() {
    int totalSeconds = 0;
    session.items.asMap().forEach((index, classes.SessionItemComplete sessionItem) {
      if (index > sessionIndex) return;

      if (sessionItem.imageAmount == -1) {
        totalSeconds = sessionItem.timeAmount * imagePaths.length;
      } else {
        totalSeconds += sessionItem.timeAmount;
      }
    });

    Duration totalDuration = Duration(seconds: totalSeconds);
    String minutes = totalDuration.inMinutes.toString();
    String seconds = (totalDuration.inSeconds % 60).toString();

    return [minutes, seconds];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
                title: sessionEnded ? const Text("Session is over") : const Text("No images left")
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                children: [
                  Text("You drew ${imageIndex + 1} images in ${getSessionLength()[0]} minutes and ${getSessionLength()[1]} seconds")
                ],
              )
            )
        ),
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (_) => false
          );

          return false;
        }
    );
  }
}
