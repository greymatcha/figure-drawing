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

  SessionItemComplete.fromJson(Map<String, dynamic> json):
    this(
      Key(json["key"]),
      json["type"] == "pause" ? SessionItemType.pause : SessionItemType.draw,
      int.parse(json["timeAmount"]),
      int.parse(json["imageAmount"])
    );

  Map<String, dynamic> toJson() => {
    "key": key.toString(),
    "type": type == SessionItemType.pause ? "pause" : "draw",
    "timeAmount": timeAmount,
    "imageAmount": imageAmount,
  };
}

class Session {
  String id;
  String title;
  List<SessionItemComplete> items;

  Session(this.id, this.title, this.items);

  Session.fromJson(Map<String, dynamic> json):
    this(
      json["id"],
      json["title"],
      json["items"].map((jsonSessionItem) => SessionItemComplete.fromJson(jsonSessionItem)).toList()
    );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "items": items.map((sessionItem) => sessionItem.toJson()).toList()
  };
}

class SessionStorageData {
  List<Session> sessions;
  String? lastActive;

  SessionStorageData(this.sessions, this.lastActive);

  SessionStorageData.fromJson(Map<String, dynamic> json):
      this(
        json["sessions"].map((jsonSession) => Session.fromJson(jsonSession)).toList(),
        json["lastActive"] == "" ? null : json["lastActive"] // Set it to null if it was an empty string
      );

  Map<String, dynamic> toJson() => {
    "sessions": sessions.map((session) => session.toJson()).toList(),
    "lastActive": lastActive ?? "" // Set it to an empty string if it is null
  };
}
