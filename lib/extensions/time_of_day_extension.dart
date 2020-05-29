import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  TimeOfDay substractMinutes(int minutes) {
    var timeValue = this.hour * 60 + this.minute;
    timeValue = timeValue - minutes;
    if (timeValue < 0) {
      return TimeOfDay(hour: 24, minute: 0).substractMinutes(timeValue);
    }
    return TimeOfDay(hour: timeValue ~/ 60, minute: timeValue % 60);
  }

  bool isInInterval(TimeOfDay start, int duration) {
    return this.getTicks() >= start.getTicks() &&
        this.getTicks() < (start.getTicks() + duration);
  }

  int getTicks() {
    return this.hour * 60 + this.minute;
  }
}
