import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' hide Animation;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:super_mario_game/gameElements/coins.dart';
import 'package:super_mario_game/gameElements/mario.dart';
import 'package:tiled/tiled.dart';
import 'package:flame_tiled/flame_tiled.dart';

enum MarioState {
  idle,
  runningLeft,
  runningRight,
  jumpLeft,
  jumpRight,
}

class SuperMario extends BaseGame with HasCollidables {
  TiledComponent tiledMap;
  Coins coins;
  Mario mario;
  double ax = 0, ay = 0;
  ObjectGroup objGroup;

  Future<void> onLoad() async {
    super.onLoad();

    await Flame.device.setLandscapeLeftOnly();

    tiledMap = TiledComponent('Map.tmx', Size(16, 16));

//Layer

    add(tiledMap);

//Object Groups
    objGroup = await tiledMap.getObjectGroupFromLayer("coins");

    print(objGroup.name.toString());

    print(objGroup.objects[0].name.toString());

    // objGroup.objects.forEach((TiledObject obj) {
    //   final comp = SpriteAnimationComponent(
    //     animation: SpriteAnimation.fromFrameData(
    //       sprite.image,
    //       SpriteAnimationData.sequenced(
    //         amount: 8,
    //         textureSize: Vector2.all(20),
    //         stepTime: 0.15,
    //       ),
    //     ),
    //     position: Vector2(obj.x, obj.y),
    //     size: Vector2.all(20),
    //   );

    //   add(comp);
    // });

    objGroup.objects.forEach((TiledObject obj) {
      obj.properties.forEach((element) {
        if (element.value == '0') {
          coins = Coins();
          coins.position = Vector2(obj.x, obj.y);
          add(coins);
        }
      });
    });

    debugMode = true;

    mario = Mario();

    add(mario);

//camera

    viewport = FixedResolutionViewport(Vector2(size.x, size.y));

    camera.zoom = 1.6;

    print(viewport.effectiveSize.toString());

//Accel Values

    accelerometerEvents.listen((AccelerometerEvent event) {
      ay = event.y;
      // print(ay.toString());
    });
  }

  void update(double dt) {
    super.update(dt);

    if (ay.isNegative && mario.x < -50) {
    } else if (ay > 0 && mario.x > 200 * 16) {
    } else {
      if (ay.isNegative) {
        //left
        mario.x = mario.x.abs() + ay;

        mario.current = MarioState.runningLeft;
      } else {
        //right
        mario.current = MarioState.runningRight;
        mario.x = mario.x.abs() + ay;
      }
    }
    camera.followVector2(Vector2(mario.x, size.y / 2));
  }
}
