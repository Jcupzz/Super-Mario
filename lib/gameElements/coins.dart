import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/position_body_component.dart';

class Coins extends PositionBodyComponent {
  final Vector2 position;

  Coins(PositionComponent component, this.position)
      : super(component, component.size);
  @override
  Body createBody() {
    // debugMode = true;
    final shape = PolygonShape()..setAsBoxXY(8, 8);
    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision
      ..restitution = 0.8
      ..density = 1.0
      ..friction = 0.2;

    final bodyDef = BodyDef()
      ..position = position
      ..type = BodyType.static;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  Future<void> onLoad() async {
    super.onLoad();
    debugMode = true;
  }

  void update(double dt) {
    super.update(dt);
  }
}
