import 'dart:async' as asyncw;
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_tiled/tiled_component.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:super_mario_game/gameElements/coins.dart';
import 'package:super_mario_game/gameElements/downBricks.dart';
import 'package:super_mario_game/gameElements/mario.dart';
import 'package:super_mario_game/gameElements/pipes.dart';
import 'package:super_mario_game/gameElements/platform.dart';
import 'package:tiled/tiled.dart';

enum MarioState {
  idleLeft,
  idleRight,
  runningLeft,
  runningRight,
  jumpLeft,
  jumpRight,
}

class SuperMario extends Forge2DGame {
  Image coinImg;
  SpriteAnimation coinSpriteAnimation;
  TiledComponent tiledMap;
  ObjectGroup coinsGroup;
  ObjectGroup pipesGroup;
  ObjectGroup platformGroup;

  //JUMP
  bool onceExecuted = false;
  bool cancelX = false;

  asyncw.Timer timer;

  ObjectGroup downBricksGroup;
  SpriteAnimationComponent animationComponent;
  SpriteAnimationGroupComponent<MarioState> marioAnimationGroupComponent;
  Coins coins;
  MarioState currentStateOfMario = MarioState.idleRight;
  double ay = 0;
  double ax = 0;
  Mario mario;

  SuperMario() : super(gravity: Vector2(0, -10), zoom: 1.5);

  Future<void> onLoad() async {
    super.onLoad();
    addContactCallback(CoinsContactCallback());

    await Flame.device.setOrientation(DeviceOrientation.landscapeLeft);

//TiledMap

    tiledMap = TiledComponent('Map.tmx', Size(16, 16));
    add(tiledMap);

//Object Groups

    //Coins
    debugMode = true;

    coinImg = await images.load('coins.png');

    coinSpriteAnimation = SpriteAnimation.fromFrameData(
      coinImg,
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2.all(20),
        stepTime: 0.2,
        loop: true,
      ),
    );

    coinsGroup = await tiledMap.getObjectGroupFromLayer("coins");
    coinsGroup.objects.forEach((TiledObject obj) {
      final spriteSize = Vector2.all(16);
      animationComponent = SpriteAnimationComponent(
        animation: coinSpriteAnimation,
        size: spriteSize,
      );
      add(Coins(
          animationComponent,
          (Vector2(obj.x + obj.width / 2, -obj.y - obj.height / 2)),
          obj.width,
          obj.height));
    });

    //Mario
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

    final idleRightSpriteAnimation =
        marioSpriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 7, to: 8);

    final idleLeftSpriteAnimation =
        marioSpriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 6, to: 7);

    final jumpRightSpriteAnimation = marioSpriteSheet.createAnimation(
        row: 0, stepTime: 0.1, from: 12, to: 13);

    final jumpLeftSpriteAnimation =
        marioSpriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 1, to: 2);

    marioAnimationGroupComponent = SpriteAnimationGroupComponent(
      animations: {
        MarioState.runningLeft: runLeftSpriteAnimation,
        MarioState.runningRight: runRightSpriteAnimation,
        MarioState.idleLeft: idleLeftSpriteAnimation,
        MarioState.idleRight: idleRightSpriteAnimation,
        MarioState.jumpRight: jumpRightSpriteAnimation,
        MarioState.jumpLeft: jumpLeftSpriteAnimation
      },
      current: currentStateOfMario,
      position: Vector2(size.x / 2, -size.y + 70),
      size: Vector2(27, 34.25),
    );

    mario =
        Mario(Vector2(size.x / 2, -size.y + 70), marioAnimationGroupComponent);
    add(mario);

    // DownBricks

    downBricksGroup = await tiledMap.getObjectGroupFromLayer("downBricks");

    double h = downBricksGroup.objects[0].height;
    double w = downBricksGroup.objects[0].width;
    double dbx = downBricksGroup.objects[0].x;
    double dby = downBricksGroup.objects[0].y;

    add(DownBricks(Vector2(dbx + w / 2, -(dby) - h / 2)));

    //Pipes
    pipesGroup = await tiledMap.getObjectGroupFromLayer("pipes");
    pipesGroup.objects.forEach((TiledObject obj) {
      add(Pipes(Vector2(obj.x + obj.width / 2, -obj.y - obj.height / 2),
          obj.width, obj.height));
    });

    //Plaform
    platformGroup = await tiledMap.getObjectGroupFromLayer("platform");
    platformGroup.objects.forEach((TiledObject obj) {
      add(Platform(Vector2(obj.x + obj.width / 2, -obj.y - obj.height / 2),
          obj.width, obj.height));
    });

//camera
    // screenToWorld(Vector2(viewport.effectiveSize.x, viewport.effectiveSize.y));

    print(viewport.effectiveSize.toString());

//Accel Values
    accelerometerEvents.listen((AccelerometerEvent event) {
      ax = event.x;
      ay = event.y;
    });
  }

  void update(double dt) {
    super.update(dt);

    //Running Logic
    if (!cancelX) {
      if (ay.isNegative && ay < -1.5) {
        //left
        mario.body.linearVelocity =
            mario.body.linearVelocity - Vector2(dt * 200, 0);

        marioAnimationGroupComponent.current = MarioState.runningLeft;
        currentStateOfMario = MarioState.runningLeft;
      } else if (ay > 1.5) {
        //right
        mario.body.linearVelocity =
            mario.body.linearVelocity + Vector2(dt * 200, 0);

        marioAnimationGroupComponent.current = MarioState.runningRight;
        currentStateOfMario = MarioState.runningRight;
      } else {
        if (ay.isNegative) {
          mario.body.linearVelocity = Vector2(0, -10);
          marioAnimationGroupComponent.current = MarioState.idleLeft;
          currentStateOfMario = MarioState.idleLeft;
        } else {
          mario.body.linearVelocity = Vector2(0, -10);
          marioAnimationGroupComponent.current = MarioState.idleRight;
          currentStateOfMario = MarioState.idleRight;
        }
      }
    }

    //JUMP LOGIC

    if (ax < -1) {
      if (currentStateOfMario == MarioState.idleRight) {
        print("Idle Right");
        currentStateOfMario = MarioState.jumpRight;
        marioAnimationGroupComponent.current = MarioState.jumpRight;
        if (!onceExecuted) {
          jumpRight();
          cancelX = true;
          onceExecuted = true;
        }
      } else if (currentStateOfMario == MarioState.idleLeft) {
        print("Idle Left");

        currentStateOfMario = MarioState.jumpLeft;
        marioAnimationGroupComponent.current = MarioState.jumpLeft;
        if (!onceExecuted) {
          cancelX = true;
          onceExecuted = true;
          jumpLeft();
        }
      }
    }

    camera.followComponent(mario.positionComponent);
  }

  void jumpLeft() {
    double time = 0;
    asyncw.Timer.periodic(Duration(milliseconds: 30), (sec) {
      time += 1;

      if (time < 90) {
        if (time < 45) {
          mario.body.linearVelocity =
              mario.body.linearVelocity + Vector2(-80, 200);
        } else if (time > 45) {
          mario.body.linearVelocity =
              mario.body.linearVelocity + Vector2(-80, -200);
        }
      } else {
        sec.cancel();
        onceExecuted = false;
        cancelX = false;
        print("Only executed once");
      }
    });
  }

  void jumpRight() {
    double time = 0;
    asyncw.Timer.periodic(Duration(milliseconds: 30), (sec) {
      time += 1;

      if (time < 90) {
        if (time < 45) {
          mario.body.linearVelocity =
              mario.body.linearVelocity + Vector2(80, 200);
        } else if (time > 45) {
          mario.body.linearVelocity =
              mario.body.linearVelocity + Vector2(80, -200);
        }
      } else {
        sec.cancel();
        onceExecuted = false;
        cancelX = false;
        print("Only executed once");
      }
    });
  }
}

class CoinsContactCallback extends ContactCallback<Coins, Mario> {
  @override
  void begin(Coins coinss, Mario marios, Contact contact) {
    print("contacted");
  }

  @override
  void end(Coins coinss, Mario marios, Contact contact) {
    print("contacted");
  }
}
