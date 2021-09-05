import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' hide Animation;
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:super_mario_game/SuperMario.dart';

// import 'package:flame/src/t' show ObjectGroup, TmxObject;
class MyHomePage extends StatelessWidget {
  final game = SuperMario();
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
    );
  }
}
