import 'dart:ui';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BreakingBricks extends BodyComponent {
  final Vector2 position;
  final width;
  final height;

  BreakingBricks(this.position, this.width, this.height) : super();
  @override
  Body createBody() {
    debugMode = true;
    debugColor = Color(0xff834f99);

    final shape = PolygonShape()..setAsBoxXY(width / 2 - 2, height / 6);
    final fixtureDef = FixtureDef(shape)
      // ..restitution = 0.8
      ..userData = this
      ..friction = 0;

    final bodyDef = BodyDef()
      ..userData = this // To be able to determine object in collision
      ..position = Vector2(position.x, position.y - 5.5)
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
