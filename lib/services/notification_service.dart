import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wakeup_kid/main.dart';
import 'package:wakeup_kid/model/wakeup_model.dart';

import 'storage_service.dart';

Future<void> showOngoingNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: true,
    autoCancel: false,
    visibility: NotificationVisibility.Public,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  var storageService = StorageService();

  var model = await storageService.getModel();

  var eventId = model.getEventForTime(TimeOfDay.now());
  if (eventId != null) {
    model.playEvent(eventId);
    var event = model.getEvent(eventId);

    await flutterLocalNotificationsPlugin.show(int.parse(eventId), 'WakeUp Kid',
        event.title, platformChannelSpecifics);
  }
}
