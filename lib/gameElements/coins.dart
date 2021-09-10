import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/position_body_component.dart';
import 'package:super_mario_game/gameElements/mario.dart';
import 'package:super_mario_game/gameElements/platform.dart';

class Coins extends PositionBodyComponent {
  final Vector2 position;
  double width;
  double height;

  Coins(PositionComponent component, this.position, this.width, this.height)
      : super(component, component.size);
  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(8, 8);
    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision
      ..restitution = 0.8
      ..density = 1.0
      ..friction = 0.2;

    final bodyDef = BodyDef()
      ..position = Vector2(position.x, position.y)
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
