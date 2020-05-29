import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakeup_kid/model/wakeup_model.dart';
import 'package:wakeup_kid/widgets/basic_date_field.dart';

class SetupForm extends StatefulWidget {
  final WakeUpModel model;

  const SetupForm({Key key, this.model}) : super(key: key);

  @override
  _SetupFormState createState() => _SetupFormState(this.model);
}

class _SetupFormState extends State<SetupForm> {
  final _formKey = GlobalKey<FormState>();

  WakeUpModel model;
  String minuteError;

  _SetupFormState(this.model);

  @override
  void initState() {
    minuteError = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: 400,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 32,
            ),
            Text(
              'Doba cesty do školy:',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '(minuty)',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: TextFormField(
                autocorrect: false,
                autofocus: true,
                initialValue: model.minutDoSkoly.toString(),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                onSaved: (text) {
                  setState(
                    () {
                      model.parseMinutDoSkoly(text);
                    },
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'zadejte čas';
                  }
                  int cas = int.tryParse(value);
                  if (cas == null) {
                    return 'zadejte číslo';
                  }
                  if (cas >= 30) {
                    return 'číslo je moc velké';
                  }

                  if (cas < 1) {
                    return 'zadejte kladné číslo';
                  }

                  return null;
                },
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Čas, kdy vezmu za kliku školy:',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: BasicTimeField(
                initTime: model.casStartuSkoly,
                onSaved: (time) {
                  setState(
                    () {
                      model.casStartuSkoly =
                          TimeOfDay(hour: time.hour, minute: time.minute);
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          model.rescheduleEvents();
                          Navigator.of(context).pop(model);
                        }
                      },
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
