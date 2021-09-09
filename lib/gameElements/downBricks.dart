import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/src/dynamics/body.dart';

class DownBricks extends BodyComponent {
  final Vector2 position;
  DownBricks(this.position) : super();
  @override
  Body createBody() {
    debugMode = false;
    final shape = PolygonShape()..setAsBoxXY(1600, 16);
    final fixtureDef = FixtureDef(shape)
      ..userData = this; // To be able to determine object in collision
    // ..restitution = 0.8
    // ..friction = 0.2;

    final bodyDef = BodyDef()
      ..position = position
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
