import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:wakeup_kid/model/wakeup_model.dart';

class StorageService {
  static const String modelStoreName = 'wakeup_model';
  static const String lastAlarmIdStoreName = 'wakeup_model';
  static const String alarmInstanceId = 'alarm_instance_id';

  StorageService();

  Future<File> _getStorageFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return File('${appDocDir.path}/counter.txt');
  }

  Future<WakeUpModel> getModel() async {
    var file = await _getStorageFile();
    if (file != null && await file.exists()) {
      var json = file.readAsStringSync();
      return WakeUpModel.fromJson(jsonDecode(json));
    }

    return WakeUpModel();
  }

  Future<void> saveModel(WakeUpModel model) async {
    var modelJson = jsonEncode(model);
    final file = await _getStorageFile();
    file.writeAsString(modelJson);
  }
}
