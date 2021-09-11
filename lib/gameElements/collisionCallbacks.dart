import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:super_mario_game/gameElements/coins.dart';
import 'package:super_mario_game/gameElements/mario.dart';

class CoinsContactCallback extends ContactCallback<Coins, Mario> {
  @override
  void begin(Coins coinss, Mario marios, Contact contact) {
    print("contacted");
    coinss.remove();
  }

  @override
  void end(Coins coinss, Mario marios, Contact contact) {
    print("contacted");
  }
}
