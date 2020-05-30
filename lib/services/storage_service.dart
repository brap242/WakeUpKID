import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakeup_kid/model/wakeup_model.dart';

class StorageService {
  static const String modelStoreName = 'wakeup_model';
  static const String lastAlarmIdStoreName = 'wakeup_model';
  static const String alarmInstanceId = 'alarm_instance_id';

  StorageService();

  Future<WakeUpModel> getModel() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.reload();
    var modelJsonData = prefs.getString(modelStoreName);
    return modelJsonData != null
        ? WakeUpModel.fromJson(jsonDecode(modelJsonData))
        : WakeUpModel();
  }

  Future<void> saveModel(WakeUpModel model) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.reload();
    var modelData = model.toJson();
    await prefs.setString(modelStoreName, jsonEncode(modelData));
    prefs.reload();
  }

  Future<String> getLastActiveAlarmId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastAlarmIdStoreName);
  }

  Future<void> saveLastActiveAlarmId(String alarmId) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastAlarmIdStoreName, alarmId);
  }

  // Future<int> getAlarmInstanceId() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   return prefs.getInt(alarmInstanceId);
  // }

  // Future<void> saveAlarmInstanceId(int alarmId) async {
  //   var prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt(alarmInstanceId, alarmId);
  // }
}
