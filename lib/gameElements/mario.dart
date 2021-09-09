import 'dart:ui';
import 'dart:async' as asyncw;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/tiled_component.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:super_mario_game/SuperMario.dart';
import 'package:tiled/tiled.dart';

import 'package:super_mario_game/gameElements/coins.dart';

class Mario extends SpriteAnimationGroupComponent<MarioState>
    with HasGameRef<SuperMario>, Hitbox, Collidable {
  bool collided = false;
  ObjectGroup objGroup;
  asyncw.Timer timer;

  Coins coins;
  SuperMario superMario;
  Vector2 velocity = Vector2(2, 2);
  Vector2 gravity = Vector2(0, -2);

  double ax = 0, ay = 0;

  //Jump

  double time = 0;
  double height = 0;

  double initialHeight = 0;

  bool onceExecuted = false;

  bool cancelX = false;

  bool cancelRight = false;

  double speedOfMario = 1;

  MarioState currentStateOfMario = MarioState.idleRight;

  bool cancelLeft = false;

  Future<void> onLoad() async {
    super.onLoad();
    superMario = SuperMario();
    coins = Coins();

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

    final idleRightSpriteAnimation =
        marioSpriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 7, to: 8);

    final idleLeftSpriteAnimation =
        marioSpriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 6, to: 7);

    final jumpRightSpriteAnimation = marioSpriteSheet.createAnimation(
        row: 0, stepTime: 0.1, from: 12, to: 13);

    final jumpLeftSpriteAnimation =
        marioSpriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 1, to: 2);

    animations = {
      MarioState.runningLeft: runLeftSpriteAnimation,
      MarioState.runningRight: runRightSpriteAnimation,
      MarioState.idleLeft: idleLeftSpriteAnimation,
      MarioState.idleRight: idleRightSpriteAnimation,
      MarioState.jumpRight: jumpRightSpriteAnimation,
      MarioState.jumpLeft: jumpLeftSpriteAnimation
    };

    position =
        Vector2(gameRef.size.x / 2 + 200, gameRef.size.y - gameRef.size.y / 5);
    size = Vector2(27, 34.25);
    anchor = Anchor.center;

    accelerometerEvents.listen((AccelerometerEvent event) {
      ay = event.y;
      ax = event.x;
      // print(ay.toString());
    });

    current = currentStateOfMario;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);

    if (other is Coins) {
      // remove();
      print(other.toRect().left.toString());
      collided = true;
    }
  }

  void onCollisionEnd(Collidable other) {
    super.onCollisionEnd(other);
    if (other is Coins) {
      collided = false;
    }
  }

  //JUMP RIGHT FUNCTION
  void jumpRight() {
    time = 0;
    initialHeight = gameRef.size.y - gameRef.size.y / 5;
    asyncw.Timer.periodic(Duration(milliseconds: 55), (Sec) {
      time += 0.5;
      height = -4.9 * time * time + 40 * time;
      x = x + 1.5;
      if (initialHeight - height > gameRef.size.y - gameRef.size.y / 5) {
        y = gameRef.size.y - gameRef.size.y / 5;
        onceExecuted = false;
        Sec.cancel();
        print("Execution completed");
        cancelX = false;
      } else {
        y = initialHeight - height;
      }
    });
  }

//JUMP LEFT FUNCTION
  void jumpLeft() {
    time = 0;
    initialHeight = gameRef.size.y - gameRef.size.y / 5;
    asyncw.Timer.periodic(Duration(milliseconds: 55), (Sec) {
      time += 0.7;
      height = -4.9 * time * time + 40 * time;
      x = x - 3;
      if (initialHeight - height > gameRef.size.y - gameRef.size.y / 5) {
        y = gameRef.size.y - gameRef.size.y / 5;
        onceExecuted = false;
        Sec.cancel();
        print("Execution completed");
        cancelX = false;
      } else {
        y = initialHeight - height;
      }
    });
  }

  void update(double dt) {
    super.update(dt);
    // print(x.toString());
    // objGroup.objects.forEach((TiledObject obj) {
    //   if (x > obj.x && x < (obj.x + obj.width)) {}
    // });
    if (collided) {
      // speedOfMario = 0;
      cancelRight = true;
      cancelLeft = true;
    } else {
      cancelRight = false;
      cancelLeft = false;
      // speedOfMario = 1;
    }

    //JUMP LOGIC
    if (ax < -1) {
      if (currentStateOfMario == MarioState.idleRight) {
        print("Idle Right");
        current = MarioState.jumpRight;
        currentStateOfMario = MarioState.jumpRight;
        if (!onceExecuted) {
          jumpRight();
          cancelX = true;
          onceExecuted = true;
        }
      } else if (currentStateOfMario == MarioState.idleLeft) {
        print("Idle Left");
        current = MarioState.jumpLeft;
        currentStateOfMario = MarioState.jumpLeft;
        if (!onceExecuted) {
          jumpLeft();
          cancelX = true;
          onceExecuted = true;
        }
      }
    }

//RUNNING LOGIC
//IDLE STATE LOGIC
    if (!cancelX) {
      if (ay.isNegative && x < -50) {
      } else if (ay > 0 && x > 200 * 16) {
      } else {
        if (ay.isNegative && ay < -1.5) {
          //left
          if (!cancelLeft) {
            x = x.abs() + ay * speedOfMario;
            currentStateOfMario = MarioState.runningLeft;
            current = MarioState.runningLeft;
            // cancelLeft = true;
          }
        } else if (ay > 1.5) {
          //right
          if (!cancelRight) {
            current = MarioState.runningRight;
            currentStateOfMario = MarioState.runningRight;
            x = x.abs() + ay * speedOfMario;
            // cancelRight = true;
          }
        } else {
          if (ay.isNegative) {
            current = MarioState.idleLeft;
            currentStateOfMario = MarioState.idleLeft;
          } else {
            current = MarioState.idleRight;
            currentStateOfMario = MarioState.idleRight;
          }
        }
      }
    }
  }
}
