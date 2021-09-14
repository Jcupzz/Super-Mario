import 'dart:async' as asyncw;
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_tiled/tiled_component.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:super_mario_game/gameElements/coins.dart';
import 'package:super_mario_game/gameElements/collisionCallbacks.dart';
import 'package:super_mario_game/gameElements/downBricks.dart';
import 'package:super_mario_game/gameElements/mario.dart';
import 'package:super_mario_game/gameElements/pipes.dart';
import 'package:super_mario_game/gameElements/platform.dart';
import 'package:super_mario_game/main.dart';
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
  ObjectGroup startAndEnd;

  //JUMP

  asyncw.Timer timer;

  ObjectGroup downBricksGroup;
  SpriteAnimationComponent animationComponent;
  SpriteAnimationGroupComponent<MarioState> marioAnimationGroupComponent;
  Coins coins;
  double ay = 0;
  double ax = 0;
  Mario mario;

  asyncw.Timer timerObjVar;

  bool immediatlyCancelTimer = false;

  SuperMario() : super(gravity: Vector2(0, -10), zoom: 1.6);

  Future<void> onLoad() async {
    super.onLoad();
    currentStateOfMario = MarioState.idleRight;

    camera.worldBounds =
        Rect.fromLTWH(0, 0, viewport.effectiveSize.x, viewport.effectiveSize.y);
//gravity

//Contact Callbacks
    addContactCallback(CoinsContactCallback());
    addContactCallback(MarioPlatform());
    addContactCallback(MarioDownBricks());
    addContactCallback(MarioPipes());

    await Flame.device.setOrientation(DeviceOrientation.landscapeLeft);

//TiledMap

    tiledMap = TiledComponent('Map.tmx', Size(16, 16));
    add(tiledMap);

//Object Groups

    //Coins
    debugMode = false;

    coinImg = await images.load('coins.png');

    coinSpriteAnimation = SpriteAnimation.fromFrameData(
      coinImg,
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2.all(20),
        stepTime: 0.3,
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

    //Start and end position of mario
    startAndEnd = await tiledMap.getObjectGroupFromLayer("events");
    double marioStartPosX = startAndEnd.objects[0].x;
    double marioStartPosY = startAndEnd.objects[0].y;
    double marioEndPosX = startAndEnd.objects[1].x;
    double marioEndPosY = startAndEnd.objects[1].y;

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
      position: Vector2(marioStartPosX, -marioStartPosY),
      size: Vector2(27, 34.25),
    );

    mario = Mario(
        Vector2(marioStartPosX, -marioStartPosY), marioAnimationGroupComponent);
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

    final platformImage = await Flame.images.load('tiles-5.png');

    final platformSpriteSheet = SpriteSheet(
      image: platformImage,
      srcSize: Vector2(platformImage.width / 6, platformImage.height / 6),
    );

    final platformSprite = platformSpriteSheet.getSprite(0, 5);

    platformGroup = await tiledMap.getObjectGroupFromLayer("platform");

    platformGroup.objects.forEach((TiledObject obj) {
      add(Platform(
          platformSprite,
          Vector2(obj.x + obj.width / 2, -obj.y - obj.height / 2),
          obj.width,
          obj.height));

      // add(BreakingBricks(
      //     Vector2(obj.x + obj.width / 2, -obj.y - obj.height / 2),
      //     obj.width,
      //     obj.height));
    });

//camera
    // screenToWorld(Vector2(viewport.effectiveSize.x, viewport.effectiveSize.y));
    print(viewport.effectiveSize.toString());

    accelerometerEvents.listen((AccelerometerEvent event) {
      ax = event.x;
      ay = event.y;
    });

    print("AY is : " + ax.toString());

//Accel Values
  }

  void update(double dt) {
    super.update(dt);

    //Running Logic
    if (!mario.cancelX) {
      if (ay.isNegative && ay < -1.5) {
        //left

        mario.body.applyLinearImpulse(Vector2(-1000, -500));

        marioAnimationGroupComponent.current = MarioState.runningLeft;
        currentStateOfMario = MarioState.runningLeft;
      } else if (ay > 1.5) {
        // body.linearVelocity =
        //     body.linearVelocity + Vector2(dt * 400, 0);

        mario.body.applyLinearImpulse(Vector2(1000, -500));
        //right

        marioAnimationGroupComponent.current = MarioState.runningRight;
        currentStateOfMario = MarioState.runningRight;
      } else {
        if (ay.isNegative) {
          mario.body.linearVelocity = Vector2(0, -500);
          marioAnimationGroupComponent.current = MarioState.idleLeft;
          currentStateOfMario = MarioState.idleLeft;
        } else {
          mario.body.linearVelocity = Vector2(0, -500);
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
        if (!mario.onceExecutedRight) {
          mario.jumpRight();
          mario.cancelX = true;
          mario.onceExecutedRight = true;
        }
      } else if (currentStateOfMario == MarioState.idleLeft) {
        print("Idle Left");

        currentStateOfMario = MarioState.jumpLeft;
        marioAnimationGroupComponent.current = MarioState.jumpLeft;
        if (!mario.onceExecutedLeft) {
          mario.jumpLeft();
          mario.cancelX = true;
          mario.onceExecutedLeft = true;
        }
      }
    }
  }
}
