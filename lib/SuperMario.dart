import 'dart:async' as asyncw;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Animation;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:super_mario_game/gameElements/coins.dart';
import 'package:super_mario_game/gameElements/mario.dart';
import 'package:tiled/tiled.dart';
import 'package:flame_tiled/flame_tiled.dart';

enum MarioState {
  idleLeft,
  idleRight,
  runningLeft,
  runningRight,
  jumpLeft,
  jumpRight,
}

class SuperMario extends BaseGame with HasCollidables {
  asyncw.Timer timer;
  TiledComponent tiledMap;
  Coins coins;
  Mario mario;
  ObjectGroup objGroup;

  Future<void> onLoad() async {
    super.onLoad();

    await Flame.device.setOrientation(DeviceOrientation.landscapeLeft);

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
      coins = Coins();
      coins.position = Vector2(obj.x, obj.y);
      add(coins);
    });

    debugMode = true;

    mario = Mario();

    add(mario);

//camera

    viewport = FixedResolutionViewport(Vector2(size.x, size.y));

    camera.zoom = 1.6;

    print(viewport.effectiveSize.toString());

//Accel Values
  }

  void update(double dt) {
    super.update(dt);

    camera.followVector2(Vector2(mario.x, size.y / 2));
  }
}
