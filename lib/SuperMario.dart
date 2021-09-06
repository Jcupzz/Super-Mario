import 'dart:async' as asyncw;

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
  double ax = 0, ay = 0;
  ObjectGroup objGroup;
  MarioState currentStateOfMario = MarioState.idleRight;

//Jump

  double time = 0;
  double height = 0;

  double initialHeight = 0;

  bool onceExecuted = false;

  bool cancelX = false;

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

    mario.current = currentStateOfMario;

    add(mario);

//camera

    viewport = FixedResolutionViewport(Vector2(size.x, size.y));

    camera.zoom = 1.6;

    print(viewport.effectiveSize.toString());

//Accel Values

    accelerometerEvents.listen((AccelerometerEvent event) {
      ay = event.y;
      ax = event.x;
      // print(ay.toString());
    });
  }

  void jumpRight() {
    time = 0;
    initialHeight = size.y - size.y / 5;
    asyncw.Timer.periodic(Duration(milliseconds: 60), (Sec) {
      time += 0.5;
      height = -4.9 * time * time + 40 * time;
      mario.x = mario.x + time;
      if (initialHeight - height > size.y - size.y / 5) {
        mario.y = size.y - size.y / 5;
        onceExecuted = false;
        Sec.cancel();
        print("Execution completed");
        cancelX = false;
      } else {
        mario.y = initialHeight - height;
      }
    });
  }

  void update(double dt) {
    super.update(dt);
    if (currentStateOfMario == MarioState.idleRight) {
      if (ax < -1) {
        print("Idle Right");
        mario.current = MarioState.jumpRight;
        currentStateOfMario = MarioState.jumpRight;
        if (!onceExecuted) {
          jumpRight();
          cancelX = true;
          onceExecuted = true;
        }
      } else if (ax > 1.5) {}
    }

    if (!cancelX) {
      if (ay.isNegative && mario.x < -50) {
      } else if (ay > 0 && mario.x > 200 * 16) {
      } else {
        if (ay.isNegative && ay < -1.5) {
          //left
          mario.x = mario.x.abs() + ay;

          currentStateOfMario = MarioState.runningLeft;
          mario.current = MarioState.runningLeft;
        } else if (ay > 1.5) {
          //right
          mario.current = MarioState.runningRight;

          currentStateOfMario = MarioState.runningRight;
          mario.x = mario.x.abs() + ay;
        } else {
          if (ay.isNegative) {
            mario.current = MarioState.idleLeft;
            currentStateOfMario = MarioState.idleLeft;
          } else {
            mario.current = MarioState.idleRight;
            currentStateOfMario = MarioState.idleRight;
          }
        }
      }
    }

    camera.followVector2(Vector2(mario.x, size.y / 2));
  }
}
