import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wakeup_kid/model/wakeup_item.dart';
import '../extensions/time_of_day_extension.dart';
import '../kid_colors.dart';

class WakeUpModel {
  List<WakeUpItem> events;

  int minutDoSkoly;
  TimeOfDay casStartuSkoly;

  String lastStartedAlarmId;

  bool isMute;
  bool editMode;

  WakeUpModel() {
    isMute = false;

    casStartuSkoly = TimeOfDay(hour: 07, minute: 45);
    minutDoSkoly = 10;

    editMode = true;

    events = List<WakeUpItem>();
    _loadDefaultData();
  }

  factory WakeUpModel.fromJson(Map<String, dynamic> json) {
    var result = WakeUpModel();

    result.events.clear();

    var eventsJson = jsonDecode(json['events']);
    eventsJson.forEach((e) => result.events.add(WakeUpItem.fromJson(e)));

    result.minutDoSkoly = json['minutDoSkoly'] as int;
    result.casStartuSkoly = TimeOfDay.fromDateTime(
        DateTime.parse(json['casStartuSkoly'] as String));
    result.isMute = json['isMute'] as bool;
    result.editMode = json['editMode'] as bool;
    result.lastStartedAlarmId = json['lastStartedAlarmId'] as String;

    return result;
  }

  Map<String, dynamic> toJson() {
    var eventsEnc = events.map((e) => e.toJson()).toList();
    var result = <String, dynamic>{
      'events': jsonEncode(eventsEnc),
      'minutDoSkoly': minutDoSkoly,
      'casStartuSkoly':
          DateTime(2020, 01, 01, casStartuSkoly.hour, casStartuSkoly.minute)
              .toIso8601String(),
      'isMute': isMute,
      'editMode': editMode,
      'lastStartedAlarmId': lastStartedAlarmId
    };
    return result;
  }

  WakeUpItem getEvent(String id) {
    return events.firstWhere((element) => element.id == id);
  }

  List<WakeUpItem> getEvents({bool isEditing}) => isEditing
      ? events
      : events.where((element) => element.isEnabled).toList();

  String getEventForTime(TimeOfDay time) {
    // var item = events.firstWhere(
    //     (event) => event.time.isInInterval(time, event.duration),
    //     orElse: () => null);
    // return item?.id ?? null;
    for (var event in events) {
      if (event.isEnabled) {
        print(
            '${time.hour}:${time.minute} x ${event.time.hour}:${event.time.minute}');

        if (event.time.isInInterval(time, event.duration)) {
          print('udalost nalezena');
          return event.id;
        }
      }
    }

    return null;
  }

  void parseMinutDoSkoly(String text) {
    minutDoSkoly = int.tryParse(text);
  }

  void playEvent(String id) {
    if (isMute) {
      playNone();
    } else {
      events.forEach((event) => event.isPlaying = (event.id == id));
      rescheduleEvents();
    }
  }

  void playNone() {
    events.forEach((event) => event.isPlaying = false);
  }

  void toggleEnable(String id, bool value) {
    events.firstWhere((element) => element.id == id).isEnabled = value;
    rescheduleEvents();
  }

  void moveUpEvent(String id) {
    var item = events.singleWhere((element) => element.id == id);
    if (item != null) {
      var indexOfItem = events.indexOf(item);
      if (indexOfItem > 0) {
        events.remove(item);
        indexOfItem--;
        events.insert(indexOfItem, item);
      }
    }
  }

  void moveDownEvent(String id) {
    var item = events.singleWhere((element) => element.id == id);
    if (item != null) {
      var indexOfItem = events.indexOf(item);
      if (indexOfItem > 0) {
        events.remove(item);
        indexOfItem++;
        events.insert(indexOfItem, item);
      }
    }
  }

  void rescheduleEvents() async {
    int duration = minutDoSkoly;
    TimeOfDay startTime = casStartuSkoly.substractMinutes(duration);
    events.last.duration = minutDoSkoly;

    for (var i = events.length - 1; i >= 0; i--) {
      events[i].time = startTime;

      if (i > 0) {
        var prevEnabledEvent = _getPrevEnabledEvent(i);

        if (prevEnabledEvent != null) {
          var prevEventDuration = prevEnabledEvent.duration;
          startTime = startTime.substractMinutes(prevEventDuration);
        }
      }
    }

    // renumber
    events.forEach((element) {
      element.order = -1;
      element.isFirst = false;
      element.isLast = false;
    });

    var enabledEvents = events.where((element) => element.isEnabled).toList();
    int order = 0;
    enabledEvents.forEach(
      (enabledEvent) {
        enabledEvent.order = order;
        enabledEvent.color = KidColors.itemGradient[order];
        order++;
      },
    );

    enabledEvents.first.isFirst = true;
    enabledEvents.last.isLast = true;
  }

  WakeUpItem _getPrevEnabledEvent(int index) {
    for (var i = index - 1; i >= 0; i--) {
      if (events[i].isEnabled) return events[i];
    }
    return null;
  }

  void _loadDefaultData() {
    events.add(
      WakeUpItem(
          id: '1',
          title: 'Vstávání',
          time: TimeOfDay(hour: 06, minute: 55),
          duration: 5,
          imageAsset: 'assets/obrazky/oko.png',
          songAsset: 'hlasky/01_vstavej_1.wav',
          color: KidColors.vstavani),
    );

    events.add(
      WakeUpItem(
          id: '2',
          title: 'Mazlení',
          time: TimeOfDay(hour: 07, minute: 00),
          duration: 7,
          imageAsset: 'assets/obrazky/srdce.png',
          songAsset: 'hlasky/05_mazleni_1.wav',
          color: KidColors.mazleni),
    );
    events.add(
      WakeUpItem(
          id: '3',
          title: 'Adekvátní ustrojování I.',
          time: TimeOfDay(hour: 07, minute: 07),
          duration: 10,
          imageAsset: 'assets/obrazky/saty.png',
          songAsset: 'hlasky/07_jdi_se_oblict_1.wav',
          color: KidColors.oblenkani),
    );
    events.add(
      WakeUpItem(
          id: '4',
          title: 'Rozcvička',
          time: TimeOfDay(hour: 07, minute: 17),
          duration: 5,
          imageAsset: 'assets/obrazky/rozcvicka.png',
          songAsset: 'hlasky/09_rozcvicka_1.wav',
          color: KidColors.rozcvicka),
    );
    events.add(
      WakeUpItem(
          id: '5',
          title: 'Snídaně',
          time: TimeOfDay(hour: 07, minute: 22),
          duration: 5,
          imageAsset: 'assets/obrazky/muffin.png',
          songAsset: 'hlasky/14_snidane_2.wav',
          color: KidColors.snidane),
    );

    events.add(
      WakeUpItem(
          id: '6',
          title: 'Covid 19',
          time: TimeOfDay(hour: 07, minute: 27),
          duration: 5,
          imageAsset: 'assets/obrazky/covid.png',
          songAsset: 'hlasky/24_uvod_hyg_pravidla.wav',
          color: KidColors.snidane),
    );

    events.add(
      WakeUpItem(
          id: '7',
          title: 'Kontrola aktovky',
          time: TimeOfDay(hour: 07, minute: 32),
          duration: 2,
          imageAsset: 'assets/obrazky/taska.png',
          songAsset: 'hlasky/16_zkontroluj_aktovku_1.wav',
          color: KidColors.kontrola_aktovky),
    );

    events.add(
      WakeUpItem(
          id: '8',
          title: 'Zuby a vlasy',
          time: TimeOfDay(hour: 07, minute: 34),
          duration: 5,
          imageAsset: 'assets/obrazky/zuby_vlasy.png',
          songAsset: 'hlasky/17_zuby_a_vlasy_1.wav',
          color: KidColors.zuby_vlasy),
    );

    events.add(
      WakeUpItem(
          id: '9',
          title: 'Adekvátní ustrojování II.',
          time: TimeOfDay(hour: 07, minute: 39),
          duration: 4,
          imageAsset: 'assets/obrazky/ustrojovani_2.png',
          songAsset: 'hlasky/20_adekvatni_ustroj_2.wav',
          color: KidColors.adekvatni_ustrojovani),
    );

    events.add(
      WakeUpItem(
          id: '10',
          title: 'Odcházení z bytu',
          time: TimeOfDay(hour: 07, minute: 43),
          duration: 2,
          imageAsset: 'assets/obrazky/odchazeni.png',
          songAsset: 'hlasky/21_odchazime_z_bytu_1.wav',
          color: KidColors.odchazeni),
    );

    events.add(
      WakeUpItem(
          id: '11',
          title: 'Cesta do školy',
          time: TimeOfDay(hour: 07, minute: 45),
          duration: 5,
          imageAsset: 'assets/obrazky/cesta_do_skoly.png',
          songAsset: 'hlasky/23_odchazeni_2_harm.wav',
          color: KidColors.cesta_do_skoly),
    );
  }
}
