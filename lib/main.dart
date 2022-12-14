import 'package:flutter/material.dart';

import 'package:figure_drawing/pages/home/home.dart';

void main() {
  runApp(const FigureDrawingApp());
}

class FigureDrawingApp extends StatelessWidget {
  const FigureDrawingApp({
    super.key
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Figure Drawing',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
