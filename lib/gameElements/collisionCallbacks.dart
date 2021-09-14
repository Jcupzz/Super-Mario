import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:super_mario_game/SuperMario.dart';
import 'package:super_mario_game/gameElements/breakingBricks.dart';
import 'package:super_mario_game/gameElements/coins.dart';
import 'package:super_mario_game/gameElements/downBricks.dart';
import 'package:super_mario_game/gameElements/mario.dart';
import 'package:super_mario_game/gameElements/pipes.dart';
import 'package:super_mario_game/gameElements/platform.dart';
import 'package:forge2d/src/dynamics/body.dart';

class CoinsContactCallback extends ContactCallback<Coins, Mario> {
  @override
  void begin(Coins coins, Mario mario, Contact contact) {
    print("contacted");
    coins.remove();
  }

  @override
  void end(Coins coins, Mario mario, Contact contact) {
    print("contacted");
  }
}

class MarioBreakingBricks extends ContactCallback<Mario, BreakingBricks> {
  @override
  void begin(Mario mario, BreakingBricks breakingBricks, Contact contact) {
    print("sdfjdkfjdfs");
    mario.timer.cancel();
    mario.onceExecuted = false;
    mario.cancelX = false;
    breakingBricks.remove();
  }

  @override
  void end(Mario mario, BreakingBricks breakingBricks, Contact contact) {
    mario.timer.cancel();
    mario.onceExecuted = false;
    mario.cancelX = false;
    breakingBricks.remove();
  }
}

class MarioPlatform extends ContactCallback<Mario, Platform> {
  @override
  void begin(Mario mario, Platform platform, Contact contact) {
    if (contact.fixtureA.userData == "er") {
      print("ooooooooooooooooooooooo");
      platform.remove();
    }

    mario.timer.cancel();
    mario.onceExecuted = false;
    mario.cancelX = false;
  }

  @override
  void end(Mario mario, Platform platform, Contact contact) {
    mario.timer.cancel();
    mario.onceExecuted = false;
    mario.cancelX = false;
  }
}

class MarioDownBricks extends ContactCallback<Mario, DownBricks> {
  @override
  void begin(Mario mario, DownBricks downBricks, Contact contact) {}

  @override
  void end(Mario mario, DownBricks downBricks, Contact contact) {}
}

class MarioPipes extends ContactCallback<Mario, Pipes> {
  @override
  void begin(Mario mario, Pipes pipes, Contact contact) {}

  @override
  void end(Mario mario, Pipes pipes, Contact contact) {}
}
