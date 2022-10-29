import 'package:flutter/material.dart';

class UserSettings {
  int timeBetweenImages;

  UserSettings(this.timeBetweenImages);
}

enum SessionItemType { pause, draw }

class SessionItem {
  Key key;
  SessionItemType type;

  // For a break, this decides how long the break is. For an image it decides
  // how much time is spent per image.
  int? timeAmount;

  // Optional
  int? imageAmount;

  SessionItem(this.key, this.type, this.timeAmount, this.imageAmount);
}
