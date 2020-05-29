import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakeup_kid/model/wakeup_model.dart';
import 'package:wakeup_kid/screens/homepage/widgets/current_time.dart';
import 'package:wakeup_kid/screens/homepage/widgets/setup_form.dart';

import '../../main.dart';
import 'widgets/event_list_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int tickInterval = 10;

  WakeUpModel model;
  bool isEditing;
  TimeOfDay actualTime;
  Timer timer;
  int seconds;

  String lastActiveEventId;

  @override
  void initState() {
    super.initState();

    isEditing = false;
    model = WakeUpModel();
    actualTime = TimeOfDay(hour: 0, minute: 0);
    getSharedPrefs();

    lastActiveEventId = 'none';

    timer = Timer.periodic(
        Duration(seconds: tickInterval), (Timer timer) => timeCheck());

    port.listen((_) => () => timeCheck());

    actualTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var modelJsonData = prefs.getString('model');
    if (modelJsonData == null) return;
    setState(
      () {
        model = WakeUpModel.fromJson(jsonDecode(modelJsonData));
      },
    );
  }

  void timeCheck() {
    // time filter
    if (actualTime.hour == TimeOfDay.now().hour &&
        actualTime.minute == TimeOfDay.now().minute) return;

    setState(
      () {
        actualTime = TimeOfDay.now();
      },
    );

    var alarmId = model.getEventForTime(actualTime);
    if (alarmId != null && alarmId != lastActiveEventId) {
      setState(
        () {
          model.playEvent(alarmId);
          lastActiveEventId = alarmId;
        },
      );
    }
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
                    onChanged: (newValue) => setState(() {
                      model.playNone();
                      isEditing = newValue;
                    }),
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
                                  },
                            child: EventListItem(
                              isEditMode: isEditing,
                              eventItem: e,
                              currentTime: actualTime,
                              onMoveUp: () => setState(
                                () {
                                  model.moveUpEvent(e.id);
                                  model.rescheduleEvents();
                                },
                              ),
                              onMoveDown: () => setState(
                                () {
                                  model.moveDownEvent(e.id);
                                  model.rescheduleEvents();
                                },
                              ),
                              onMinusDuration: () => setState(
                                () {
                                  e.durationMinus();
                                  model.rescheduleEvents();
                                },
                              ),
                              onPlusDuration: () => setState(
                                () {
                                  e.durationPlus();
                                  model.rescheduleEvents();
                                },
                              ),
                              onToggleEnable: (newValue) => setState(
                                () {
                                  model.toggleEnable(e.id, newValue);
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
