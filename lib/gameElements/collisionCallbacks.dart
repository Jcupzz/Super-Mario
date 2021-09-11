import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:super_mario_game/SuperMario.dart';
import 'package:super_mario_game/gameElements/coins.dart';
import 'package:super_mario_game/gameElements/downBricks.dart';
import 'package:super_mario_game/gameElements/mario.dart';
import 'package:super_mario_game/gameElements/pipes.dart';
import 'package:super_mario_game/gameElements/platform.dart';

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

class MarioPlatform extends ContactCallback<Mario, Platform> {
  SuperMario superMario;
  @override
  void begin(Mario mario, Platform platform, Contact contact) {}

  @override
  void end(Mario mario, Platform platform, Contact contact) {}
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
