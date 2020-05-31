import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wakeup_kid/model/received_notification.dart';

import 'package:wakeup_kid/model/wakeup_model.dart';
import 'package:wakeup_kid/screens/homepage/widgets/current_time.dart';
import 'package:wakeup_kid/screens/homepage/widgets/setup_form.dart';
import 'package:wakeup_kid/services/alarm_service.dart';
import 'package:wakeup_kid/services/storage_service.dart';

import '../../main.dart';
import 'widgets/event_list_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WakeUpModel model;
  bool isEditing;
  TimeOfDay actualTime;
  Timer timer;
  int seconds;

  StorageService _storageService;
  AlarmService _alarmService;

  @override
  void initState() {
    super.initState();

    _storageService = StorageService();
    _alarmService = AlarmService();

    isEditing = false;
    model = WakeUpModel();
    actualTime = TimeOfDay(hour: 0, minute: 0);

    _storageService.getModel().then((value) => setState(() => model = value));

    actualTime = TimeOfDay.now();

    timer =
        Timer.periodic(Duration(seconds: 10), (Timer timer) => _timeCheck());

    _alarmService.initTimer();

    port.listen((_) => _timeCheck());

    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _timeCheck() async {
    // time filter
    if (actualTime.hour == TimeOfDay.now().hour &&
        actualTime.minute == TimeOfDay.now().minute) return;

    setState(
      () {
        actualTime = TimeOfDay.now();
      },
    );

    var alarmId = model.getEventForTime(actualTime);
    var lastActiveEventId = model.lastStartedAlarmId;
    if (alarmId != null && alarmId != lastActiveEventId) {
      setState(
        () {
          model.playEvent(alarmId);
          model.lastStartedAlarmId = alarmId;
          _storageService.saveModel(model);
        },
      );
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).pushNamed('/home');
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.pushNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF713684),
      appBar: AppBar(
        backgroundColor: Color(0xFF713684),
        title: Center(
          child: Text(widget.title),
        ),
        leading: IconButton(
          icon: Icon(Icons.mode_edit),
          onPressed: () {
            setState(
              () {
                model.playNone();
              },
            );
            _showSetupDialog(context, model).then(
              (value) => setState(
                () {
                  model = value;
                  _storageService.saveModel(model);
                },
              ),
            );
          },
        ),
        actions: <Widget>[
          model.isMute
              ? IconButton(
                  icon: Icon(Icons.alarm_off),
                  onPressed: () => setState(
                    () {
                      model.isMute = false;
                      model.rescheduleEvents();
                      _storageService.saveModel(model);
                    },
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.alarm_on),
                  onPressed: () => setState(
                    () {
                      model.playNone();
                      model.isMute = true;
                      model.rescheduleEvents();
                      _storageService.saveModel(model);
                    },
                  ),
                ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              Navigator.of(context).pushNamed('/about');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              CurrentTime(time: actualTime),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Editace: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Switch(
                    value: isEditing,
                    onChanged: (newValue) => setState(
                      () {
                        model.playNone();
                        isEditing = newValue;
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: model
                        .getEvents(isEditing: isEditing)
                        .map(
                          (e) => GestureDetector(
                            onTap: isEditing
                                ? null
                                : () {
                                    setState(
                                      () => model.playEvent((e.id)),
                                    );
                                    _storageService.saveModel(model);
                                  },
                            child: EventListItem(
                              isEditMode: isEditing,
                              eventItem: e,
                              currentTime: actualTime,
                              onMoveUp: () => setState(
                                () {
                                  model.moveUpEvent(e.id);
                                  model.rescheduleEvents();
                                  _storageService.saveModel(model);
                                },
                              ),
                              onMoveDown: () => setState(
                                () {
                                  model.moveDownEvent(e.id);
                                  model.rescheduleEvents();
                                  _storageService.saveModel(model);
                                },
                              ),
                              onMinusDuration: () => setState(
                                () {
                                  e.durationMinus();
                                  model.rescheduleEvents();
                                  _storageService.saveModel(model);
                                },
                              ),
                              onPlusDuration: () => setState(
                                () {
                                  e.durationPlus();
                                  model.rescheduleEvents();
                                  _storageService.saveModel(model);
                                },
                              ),
                              onToggleEnable: (newValue) => setState(
                                () {
                                  model.toggleEnable(e.id, newValue);
                                  _storageService.saveModel(model);
                                },
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<WakeUpModel> _showSetupDialog(
      BuildContext context, WakeUpModel model) async {
    return showDialog<WakeUpModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Nastavení',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          contentPadding: EdgeInsets.all(0.0),
          backgroundColor: Colors.white,
          scrollable: true,
          content: SetupForm(model: model),
        );
      },
    );
  }
}
