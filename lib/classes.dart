import 'package:flutter/material.dart';

class UserSettingsSimple {
  int timeBetweenImages;
  UserSettingsSimple(this.timeBetweenImages);
}

enum SessionItemType { pause, draw }

class SessionItem {
  Key key;
  SessionItemType type;

  SessionItem(this.key, this.type);
}

class SessionItemEdit extends SessionItem {
  int? timeAmount;
  int? imageAmount;
  SessionItemEdit(Key key, SessionItemType type, this.timeAmount, this.imageAmount) : super(key, type);
}

class SessionItemComplete extends SessionItem {
  int timeAmount;
  int imageAmount;
  SessionItemComplete(Key key, SessionItemType type, this.timeAmount, this.imageAmount) : super(key, type);
}

class Session {
  String id;
  String title;
  List<SessionItemComplete> items;

  Session(this.id, this.title, this.items);
}

class SessionStorageData {
  List<Session> sessions;
  String? lastActive;

  SessionStorageData(this.sessions, this.lastActive);
}
