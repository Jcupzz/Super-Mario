import 'dart:async' as asyncw;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_tiled/tiled_component.dart';
import 'package:flutter/services.dart';
import 'package:super_mario_game/gameElements/coins.dart';
import 'package:super_mario_game/gameElements/downBricks.dart';
import 'package:super_mario_game/gameElements/mario.dart';
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

  ObjectGroup downBricksGroup;
  SpriteAnimationComponent animationComponent;
  Coins coins;
  MarioState currentStateOfMario = MarioState.idleRight;

  asyncw.Timer timer;

  Future<void> onLoad() async {
    super.onLoad();

    await Flame.device.setOrientation(DeviceOrientation.landscapeLeft);

//TiledMap

    tiledMap = TiledComponent('Map.tmx', Size(16, 16));
    add(tiledMap);

//Object Groups

    //Coins

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
      add(Coins(animationComponent, Vector2(obj.x, -(obj.y))));
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

    final marioAnimationGroupComponent = SpriteAnimationGroupComponent(
      animations: {
        MarioState.runningLeft: runLeftSpriteAnimation,
        MarioState.runningRight: runRightSpriteAnimation,
        MarioState.idleLeft: idleLeftSpriteAnimation,
        MarioState.idleRight: idleRightSpriteAnimation,
        MarioState.jumpRight: jumpRightSpriteAnimation,
        MarioState.jumpLeft: jumpLeftSpriteAnimation
      },
      current: currentStateOfMario,
      position: Vector2(size.x / 2, -size.y / 5),
      size: Vector2(27, 34.25),
    );

    add(Mario(Vector2(size.x / 2, -size.y / 5), marioAnimationGroupComponent));

    // DownBricks

    downBricksGroup = await tiledMap.getObjectGroupFromLayer("downBricks");

    double h = downBricksGroup.objects[0].height;
    double w = downBricksGroup.objects[0].width;
    double dbx = downBricksGroup.objects[0].x;
    double dby = downBricksGroup.objects[0].y;

    add(DownBricks(Vector2(dbx, -(dby) - 16)));

//camera

    viewport = FixedResolutionViewport(Vector2(size.x, size.y));

    camera.zoom = 1.6;

    print(viewport.effectiveSize.toString());

//Accel Values
  }

  void update(double dt) {
    super.update(dt);
  }
}
