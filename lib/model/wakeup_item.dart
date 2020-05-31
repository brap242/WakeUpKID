import 'package:flutter/material.dart';

class WakeUpItem {
  String id;
  String title;
  TimeOfDay time;
  int duration;
  String imageAsset;
  String songAsset;
  Color color;
  bool isEnabled;
  int order;
  bool isFirst;
  bool isLast;
  bool isPlaying;

  int androidAllarmId = 0;

  WakeUpItem({
    this.id,
    this.title,
    this.time,
    this.duration,
    this.imageAsset,
    this.songAsset,
    this.color,
    this.isEnabled = true,
    this.order,
    this.isFirst = false,
    this.isLast = false,
    this.isPlaying = false,
    this.androidAllarmId = 0,
  });

  void durationPlus() {
    if (duration < 30) duration = duration + 1;
  }

  void durationMinus() {
    if (duration > 1) duration = duration - 1;
  }

  void toggleEnabled() {
    this.isEnabled = !isEnabled;
  }

  factory WakeUpItem.fromJson(Map<String, dynamic> json) {
    return WakeUpItem(
      id: json['id'] as String,
      title: json['title'] as String,
      time: TimeOfDay.fromDateTime(DateTime.parse(json['time'] as String)),
      duration: json['duration'] as int,
      imageAsset: json['imageAsset'] as String,
      songAsset: json['songAsset'] as String,
      color: Color(json['color'] as int),
      isEnabled: json['isEnabled'] as bool,
      order: json['order'] as int,
      isFirst: json['isFirst'] as bool,
      isLast: json['isLast'] as bool,
      //isPlaying: json['isPlaying'] as bool,
      androidAllarmId: json['androidAllarmId'] as int ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'time':
            DateTime(2020, 01, 01, time.hour, time.minute).toIso8601String(),
        'duration': duration,
        'imageAsset': imageAsset,
        'songAsset': songAsset,
        'color': color.value,
        'isEnabled': isEnabled,
        'order': order,
        'isFirst': isFirst,
        'isLast': isLast,
        //'isPlaying': isPlaying,
        'androidAllarmId': androidAllarmId
      };
}
