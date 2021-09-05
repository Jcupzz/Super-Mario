import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:super_mario_game/SuperMario.dart';
import 'package:super_mario_game/gameElements/mario.dart';
import 'package:tiled/tiled.dart';

class Coins extends SpriteAnimationComponent with Hitbox, Collidable {
  SuperMario superMario;
  double score = 0;
  Future<void> onLoad() async {
    super.onLoad();

    superMario = SuperMario();
    addShape(HitboxRectangle());
    // final ObjectGroup objGroup =
    //     await superMario.tiledMap.getObjectGroupFromLayer("coins");

    final sprite = await Sprite.load('coins.png');
    final spriteData = SpriteAnimationData.sequenced(
      amount: 8,
      textureSize: Vector2.all(20),
      stepTime: 0.1,
    );
    animation = SpriteAnimation.fromFrameData(sprite.image, spriteData);
    size = Vector2.all(15);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
    if (other is Mario) {
      remove();
      score = score + 1;
      print(score);
    }
  }
}
