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
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(13.5, 17.125);
    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision

      ..density = 0.0
      ..friction = 0.5;

    bodyDef = BodyDef()
      ..position = position
      ..userData = this // To be able to determine object in collision

      ..fixedRotation = true
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void update(double dt) {
    super.update(dt);
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
