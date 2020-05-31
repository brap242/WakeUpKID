import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wakeup_kid/services/storage_service.dart';

import 'notification_service.dart';

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

    var lastActiveAlarmId = model.lastStartedAlarmId;

    var actualTime = TimeOfDay.now();
    var alarmId = model.getEventForTime(actualTime);

    if (alarmId != null && alarmId != lastActiveAlarmId) {
      print('!!!! -event found- !!!!');

      var alarm = model.getEvent(alarmId);

      NotificationManager n = new NotificationManager();
      n.initNotificationManager();

      var notificationDetails = NotificationDetails(
          AndroidNotificationDetails(alarmId, "WakeUP Kid", alarm.title,
              importance: Importance.High),
          null);

      n.flutterLocalNotificationsPlugin.show(
          int.parse(alarmId), "WakeUP Kid", alarm.title, notificationDetails);
      //n.showNotificationWithDefaultSound("WakeUP Kid", alarm.title);

      var uiSendPort =
          IsolateNameServer.lookupPortByName('wakeup_kid_isolate_name');
      if (uiSendPort != null) {
        uiSendPort?.send(null);
      }

      return;
    }
    print('allarm manager-end');
  }
}
