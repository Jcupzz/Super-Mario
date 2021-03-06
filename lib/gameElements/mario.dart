import 'dart:math';
import 'dart:ui';
import 'dart:async' as asyncw;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/position_body_component.dart';
import 'package:flame_tiled/tiled_component.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:super_mario_game/SuperMario.dart';
import 'package:super_mario_game/main.dart';
import 'package:tiled/tiled.dart';

import 'package:super_mario_game/gameElements/coins.dart';

class Mario extends PositionBodyComponent {
  Vector2 position;

  // bool collided = false;
  // ObjectGroup objGroup;
  // asyncw.Timer timer;

  // SuperMario superMario;
  // Vector2 velocity = Vector2(2, 2);
  // Vector2 gravity = Vector2(0, -2);

  Vector2 velocity = Vector2(0, 0);
  double ax = 0, ay = 0;
  BodyDef bodyDef;

  bool onceExecutedLeft;
  bool onceExecutedRight;
  bool cancelX;

  asyncw.Timer timer;
  //Jump

  // double time = 0;
  // double height = 0;

  // double initialHeight = 0;

  // bool onceExecuted = false;

  // bool cancelX = false;

  // bool cancelRight = false;

  // double speedOfMario = 1;

  // MarioState currentStateOfMario = MarioState.idleRight;

  // bool cancelLeft = false;

  Mario(
    this.position,
    PositionComponent component,
  ) : super(component, component.size);

  Future<void> onLoad() async {
    super.onLoad();
    debugMode = false;
    onceExecutedLeft = false;
    onceExecutedRight = false;
    cancelX = false;
  }

  @override
  Body createBody() {
    final headshape = PolygonShape()
      ..setAsBox(13.5 / 2, 17.125 / 4, Vector2(0, 17.125 - 17.125 / 4), 0);

    final fixtureDef = FixtureDef(headshape)
      ..userData = "er" // To be able to determine object in collision
      ..density = 0.0
      ..friction = 0.5;

    final tailshape = PolygonShape()
      ..setAsBox(13.5, 17.125 - 17.125 / 4, Vector2(0, -17.125 / 4), 0);

    final fixtureDefs = FixtureDef(tailshape)
      ..userData = this // To be able to determine object in collision
      ..density = 0.0
      ..friction = 0.5;

    bodyDef = BodyDef()
      ..position = position
      ..userData = this // To be able to determine object in collision
      ..fixedRotation = true
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)
      ..createFixture(fixtureDefs)
      ..createFixture(fixtureDef);
  }

  void update(double dt) {
    super.update(dt);
    //Running Logic

    camera.followComponent(this.positionComponent,
        worldBounds: Rect.fromLTWH(0, 0, 3200, 224));
  }

  void jumpLeft() {
    double time = 0;
    double halfTime = 0;
    double Vy = 2500;
    double Vx = 100;
    double V = sqrt((Vx * Vx) + (Vy * Vy));
    halfTime = (V * sin(pi / 4)) / 10;
    double angle = 45 * (pi / 180);
    timer = asyncw.Timer.periodic(Duration(milliseconds: 17), (sec) {
      time = time + 2;
      if (time < halfTime * 2) {
        body.applyLinearImpulse(
            Vector2(-(Vx * cos(angle)) * 5, Vy * sin(angle) - (15) * time));
      } else {
        sec.cancel();
        onceExecutedLeft = false;

        cancelX = false;
      }
    });
  }

  void jumpRight() {
    double halfTime = 0;
    double Vy = 2500;
    double Vx = 100;
    double V = sqrt((Vx * Vx) + (Vy * Vy));
    halfTime = (V * sin(pi / 4)) / 10;
    double time = 0;
    double angle = 45 * (pi / 180);
    timer = asyncw.Timer.periodic(Duration(milliseconds: 17), (sec) {
      // timerObjVar = sec;
      time = time + 2;
      if (time < halfTime * 2) {
        body.applyLinearImpulse(
            Vector2((Vx * cos(angle)) * 5, Vy * sin(angle) - (15) * time));
      } else {
        sec.cancel();
        onceExecutedRight = false;
        cancelX = false;
      }
    });
  }

  //JUMP RIGHT FUNCTION
//   void jumpRight() {
//     time = 0;
//     initialHeight = gameRef.size.y - gameRef.size.y / 5;
//     asyncw.Timer.periodic(Duration(milliseconds: 55), (Sec) {
//       time += 0.5;
//       height = -4.9 * time * time + 40 * time;
//       x = x + 1.5;
//       if (initialHeight - height > gameRef.size.y - gameRef.size.y / 5) {
//         y = gameRef.size.y - gameRef.size.y / 5;
//         onceExecuted = false;
//         Sec.cancel();
//         print("Execution completed");
//         cancelX = false;
//       } else {
//         y = initialHeight - height;
//       }
//     });
//   }

// //JUMP LEFT FUNCTION
//   void jumpLeft() {
//     time = 0;
//     initialHeight = gameRef.size.y - gameRef.size.y / 5;
//     asyncw.Timer.periodic(Duration(milliseconds: 55), (Sec) {
//       time += 0.7;
//       height = -4.9 * time * time + 40 * time;
//       x = x - 3;
//       if (initialHeight - height > gameRef.size.y - gameRef.size.y / 5) {
//         y = gameRef.size.y - gameRef.size.y / 5;
//         onceExecuted = false;
//         Sec.cancel();
//         print("Execution completed");
//         cancelX = false;
//       } else {
//         y = initialHeight - height;
//       }
//     });
//   }

  // void update(double dt) {
  //   super.update(dt);

  // if (collided) {
  //   // speedOfMario = 0;
  //   cancelRight = true;
  //   cancelLeft = true;
  // } else {
  //   cancelRight = false;
  //   cancelLeft = false;
  //   // speedOfMario = 1;
  // }

  // //JUMP LOGIC
  // if (ax < -1) {
  //   if (currentStateOfMario == MarioState.idleRight) {
  //     print("Idle Right");
  //     // current = MarioState.jumpRight;
  //     currentStateOfMario = MarioState.jumpRight;
  //     if (!onceExecuted) {
  //       // jumpRight();
  //       cancelX = true;
  //       onceExecuted = true;
  //     }
  //   } else if (currentStateOfMario == MarioState.idleLeft) {
  //     print("Idle Left");
  //     // current = MarioState.jumpLeft;
  //     currentStateOfMario = MarioState.jumpLeft;
  //     if (!onceExecuted) {
  //       // jumpLeft();
  //       cancelX = true;
  //       onceExecuted = true;
  //     }
  //   }
  // }

//RUNNING LOGIC
//IDLE STATE LOGIC
  // if (!cancelX) {
  //   if (ay.isNegative && x < -50) {
  //   } else if (ay > 0 && x > 200 * 16) {
  //   } else {
  //     if (ay.isNegative && ay < -1.5) {
  //       //left
  //       if (!cancelLeft) {
  //         x = x.abs() + ay * speedOfMario;
  //         currentStateOfMario = MarioState.runningLeft;
  //         current = MarioState.runningLeft;
  //         // cancelLeft = true;
  //       }
  //     } else if (ay > 1.5) {
  //       //right
  //       if (!cancelRight) {
  //         current = MarioState.runningRight;
  //         currentStateOfMario = MarioState.runningRight;
  //         x = x.abs() + ay * speedOfMario;
  //         // cancelRight = true;
  //       }
  //     } else {
  //       if (ay.isNegative) {
  //         current = MarioState.idleLeft;
  //         currentStateOfMario = MarioState.idleLeft;
  //       } else {
  //         current = MarioState.idleRight;
  //         currentStateOfMario = MarioState.idleRight;
  //       }
  //     }
  //   }
  // }
  // }
}
