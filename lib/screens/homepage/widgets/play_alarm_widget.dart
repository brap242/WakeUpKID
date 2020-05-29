import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakeup_kid/kid_colors.dart';

class PlayAlarmWidget extends StatefulWidget {
  final String assetName;

  const PlayAlarmWidget({Key key, this.assetName}) : super(key: key);

  @override
  _PlayAlarmWidgetState createState() => _PlayAlarmWidgetState();
}

class _PlayAlarmWidgetState extends State<PlayAlarmWidget> {
  bool isPlaying = false;
  bool pauseAutoplay = false;

  AudioPlayer _audioPlayer;
  AudioCache _audioCache;
  StreamSubscription<void> _playerCompletionSubscription;

  @override
  void initState() {
    isPlaying = false;

    _audioPlayer = AudioPlayer();
    _audioCache = AudioCache(fixedPlayer: _audioPlayer);

    _playerCompletionSubscription = _audioPlayer.onPlayerCompletion.listen(
      (event) {
        setState(
          () {
            isPlaying = false;
          },
        );

        if (pauseAutoplay == false) {
          _startPlay();
        }
      },
    );

    _startPlay();
    super.initState();
  }

  void _startPlay() async {
    _audioCache.play(widget.assetName, volume: 99);

    setState(
      () {
        isPlaying = true;
        pauseAutoplay = false;
      },
    );
  }

  void _stopPlay() {
    _audioPlayer.stop();

    setState(
      () {
        pauseAutoplay = true;
        isPlaying = false;
      },
    );
  }

  @override
  void dispose() {
    _playerCompletionSubscription?.cancel();
    _audioPlayer?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (!isPlaying)
            FlatButton(
              textColor: KidColors.fore,
              onPressed: () => _startPlay(),
              child: Icon(Icons.play_circle_outline),
            ),
          if (isPlaying)
            FlatButton(
              color: KidColors.fore,
              onPressed: () => _stopPlay(),
              child: Icon(Icons.pause),
            ),
        ],
      ),
    );
  }
}
