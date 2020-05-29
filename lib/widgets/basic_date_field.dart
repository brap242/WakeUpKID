import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class BasicTimeField extends StatelessWidget {
  final TimeOfDay initTime;
  final Function(DateTime) onChanged;
  final Function(DateTime) onSumbited;
  final Function(DateTime) onSaved;

  const BasicTimeField(
      {Key key, this.onChanged, this.initTime, this.onSumbited, this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("HH:mm");
    var localTime = DateTime.now().toLocal();
    var initDateTime = new DateTime(
      localTime.year,
      localTime.month,
      localTime.day,
      initTime.hour,
      initTime.minute,
    );

    return DateTimeField(
      textAlign: TextAlign.center,
      resetIcon: null,
      initialValue: initDateTime,
      format: format,
      onSaved: onSaved,
      onChanged: onChanged,
      onFieldSubmitted: onSumbited,
      onShowPicker: (context, currentValue) async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        return DateTimeField.convert(time);
      },
    );
  }
}
