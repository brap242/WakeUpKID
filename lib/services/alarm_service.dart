import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:wakeup_kid/services/storage_service.dart';

class AlarmService {
  void initTimer() async {
    AndroidAlarmManager.initialize();

    await AndroidAlarmManager.periodic(
      Duration(seconds: 1),
      7589,
      checkTime,
      exact: true,
      wakeup: true,
    );
  }

  static Future<void> checkTime() async {
    print('allarm manager');
    var _storageService = StorageService();
    var model = await _storageService.getModel();

    var lastActiveAlarmId = await _storageService.getLastActiveAlarmId();

    var actualTime = TimeOfDay.now();
    var alarmId = model.getEventForTime(actualTime);

    if (alarmId != null && alarmId != lastActiveAlarmId) {
      var uiSendPort =
          IsolateNameServer.lookupPortByName('wakeup_kid_isolate_name');
      uiSendPort?.send(null);
      print('allarm manager-end');
    }
  }
}
