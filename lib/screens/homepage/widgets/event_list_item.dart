import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wakeup_kid/model/wakeup_item.dart';

import 'event_list_item_bubble.dart';
import 'play_alarm_widget.dart';

class EventListItem extends StatelessWidget {
  final WakeUpItem eventItem;

  final bool isEditMode;

  final Function() onMoveUp;
  final Function() onMoveDown;

  final Function() onPlusDuration;
  final Function() onMinusDuration;
  final Function(bool) onToggleEnable;

  final TimeOfDay currentTime;

  const EventListItem({
    Key key,
    this.eventItem,
    this.isEditMode = false,
    this.onPlusDuration,
    this.onMinusDuration,
    this.onToggleEnable,
    this.currentTime,
    this.onMoveUp,
    this.onMoveDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var minuteFormatNumber = NumberFormat("00");
    var minToGo = eventItem.time.minute - currentTime.minute;

    double height = isEditMode ? 180 : 140;
    Color backColor;

    if (isEditMode) {
      backColor = eventItem.isEnabled ? Colors.blueGrey : Colors.grey;
    } else {
      backColor = eventItem.color;
    }

    return EventListItemBuble(
      isActive: eventItem.isPlaying,
      backgroundColor: backColor,
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                TableCell(
                  child: Container(
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          eventItem.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        if (eventItem.isEnabled)
                          Text(
                            '${eventItem.time.hour}:${minuteFormatNumber.format(eventItem.time.minute)}',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        if (isEditMode)
                          Switch(
                            value: eventItem.isEnabled,
                            onChanged: (newValue) => onToggleEnable(newValue),
                          ),
                      ],
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (isEditMode &&
                            this.eventItem.isEnabled &&
                            !this.eventItem.isFirst)
                          IconButton(
                            icon: Icon(
                              Icons.arrow_upward,
                              color: Colors.white70,
                              size: 24,
                            ),
                            onPressed: onMoveUp,
                          ),
                        if (!isEditMode)
                          Image(
                            width: 60,
                            height: 60,
                            image: AssetImage(eventItem.imageAsset),
                          ),
                        if (isEditMode)
                          Image(
                            width: 60,
                            height: 60,
                            image: AssetImage(eventItem.imageAsset),
                          ),
                        SizedBox(
                          height: 4,
                        ),
                        if (minToGo > 0)
                          Text(
                            'za ${minuteFormatNumber.format(minToGo)} min',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        if (eventItem.isPlaying)
                          Container(
                            child: PlayAlarmWidget(
                              assetName: eventItem.songAsset,
                            ),
                          ),
                        if (isEditMode &&
                            this.eventItem.isEnabled &&
                            !this.eventItem.isLast)
                          IconButton(
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.white70,
                              size: 24,
                            ),
                            onPressed: onMoveDown,
                          ),
                      ],
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    width: 80,
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (isEditMode)
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white70,
                                  size: 24,
                                ),
                                onPressed: onPlusDuration,
                              ),
                            Text(
                              '${minuteFormatNumber.format(eventItem.duration)}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            if (!isEditMode)
                              Text(
                                ' min',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            if (isEditMode)
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.white70,
                                  size: 24,
                                ),
                                onPressed: onMinusDuration,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
