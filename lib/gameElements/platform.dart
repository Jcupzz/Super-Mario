import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Platform extends BodyComponent {
  final Vector2 position;
  final width;
  final height;

  Platform(this.position, this.width, this.height) : super();
  @override
  Body createBody() {
    debugMode = true;
    final shape = PolygonShape()..setAsBoxXY(width / 2, height / 2);
    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision
      // ..restitution = 0.8
      ..friction = 0;

    final bodyDef = BodyDef()
      ..position = Vector2(position.x, position.y)
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
