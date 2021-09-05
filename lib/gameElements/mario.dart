import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/tiled_component.dart';
import 'package:super_mario_game/SuperMario.dart';
import 'package:tiled/tiled.dart';

import 'package:super_mario_game/gameElements/coins.dart';

class Mario extends SpriteAnimationGroupComponent<MarioState>
    with HasGameRef<SuperMario>, Hitbox, Collidable {
  bool collided = false;
  ObjectGroup objGroup;
  Coins coins;
  Future<void> onLoad() async {
    super.onLoad();

    coins = Coins();

    final tiledMap = TiledComponent('Map.tmx', Size(16.0, 16.0));

    objGroup = await tiledMap.getObjectGroupFromLayer("coins");

    addShape(HitboxRectangle());
    final marioSpriteImage = await Flame.images.load('marioSpriteSheet.png');

    final marioSpriteSheet = SpriteSheet(
      image: marioSpriteImage,
      srcSize: Vector2(
          marioSpriteImage.width / 14, marioSpriteImage.height.toDouble()),
    );

    final runLeftSpriteAnimation = marioSpriteSheet.createAnimation(
        row: 0, stepTime: 0.15, from: 4, to: 6);

    final runRightSpriteAnimation = marioSpriteSheet.createAnimation(
        row: 0, stepTime: 0.15, from: 8, to: 10);

    final idleSpriteAnimation =
        marioSpriteSheet.createAnimation(row: 0, stepTime: 0, from: 7, to: 8);

    animations = {
      MarioState.runningLeft: runLeftSpriteAnimation,
      MarioState.runningRight: runRightSpriteAnimation,
      MarioState.idle: idleSpriteAnimation,
    };

    current = MarioState.runningRight;
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - gameRef.size.y / 5);
    size = Vector2(27, 34.25);
    anchor = Anchor.center;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);

    // if (other is Coins) {
    //   collided = true;

    //   remove();
    // }
  }

  void update(double dt) {
    super.update(dt);
    // print(x.toString());
    if (collided) {
      // objGroup.objects.forEach((TiledObject obj) {
      //   if (x > obj.x && x < (obj.x + obj.width)) {}
      // });

    } else {
      collided = false;
    }
  }
}