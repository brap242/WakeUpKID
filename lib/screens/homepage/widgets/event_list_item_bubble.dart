import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakeup_kid/kid_colors.dart';

class EventListItemBuble extends StatelessWidget {
  final Color backgroundColor;
  final List<Widget> children;
  final bool isActive;

  const EventListItemBuble(
      {Key key, this.children, this.backgroundColor, this.isActive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: isActive ? KidColors.fore : backgroundColor,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: backgroundColor),
        child: Container(
          width: MediaQuery.of(context).size.width - 10,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Column(
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
