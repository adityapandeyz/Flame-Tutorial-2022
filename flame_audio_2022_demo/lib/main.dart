import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGameAudio(),
    ),
  );
}

final style = TextStyle(color: BasicPalette.white.color);
final regular = TextPaint(style: style);

class MyGameAudio extends FlameGame with TapDetector, DoubleTapDetector {
  bool playingMusic = false;
  int trackNumber = 1;
  TextComponent instructions = TextComponent();
  final String instructiionString = 'Play: Single tap\n'
      'stop single tap\n'
      'next song: double tap ';

  @override
  Future<void> onLoad() async {
    super.onLoad();
    instructions
      ..text = '$instructiionString\ntrack number $trackNumber'
      ..textRenderer = regular
      ..y = 100
      ..x = 20;

    add(instructions);
  }

  @override
  void onTapUp(TapUpInfo info) {
    if (!playingMusic) {
      switch (trackNumber) {
        case 1:
          FlameAudio.bgm.play('track_1_rolex.mp3');
          playingMusic = true;
          break;
        case 2:
          FlameAudio.bgm.play('track_2_rrr.mp3');
          playingMusic = true;
          break;
      }
      instructions.text = '$instructiionString\ntrack number $trackNumber\n'
          'Status: playing';
    } else {
      FlameAudio.bgm.stop();
      playingMusic = false;
      instructions.text = '$instructiionString\ntrack number $trackNumber\n'
          'Status: stopped';
    }
  }

  @override
  void onDoubleTap() {
    trackNumber++;
    if (trackNumber > 2) {
      trackNumber = 1;
    }
    if (playingMusic) {
      instructions.text = '$instructiionString\ntrack number $trackNumber\n'
          'Status: playing';
    } else {
      instructions.text = '$instructiionString\ntrack number $trackNumber\n'
          'Status: stopped';
    }

    instructions.text = '$instructiionString\ntrack number $trackNumber';
  }
}
