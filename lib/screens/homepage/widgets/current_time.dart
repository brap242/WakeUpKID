import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../kid_colors.dart';

class CurrentTime extends StatelessWidget {
  final TimeOfDay time;

  const CurrentTime({Key key, this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Text(
            '${time.hour}:${NumberFormat("00").format(time.minute)}',
            style: TextStyle(color: KidColors.fore, fontSize: 24),
          ),
        )
      ],
    );
  }
}
