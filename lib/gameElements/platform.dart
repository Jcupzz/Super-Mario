import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/position_body_component.dart';
import 'package:flame_forge2d/sprite_body_component.dart';

class Platform extends SpriteBodyComponent {
  final Vector2 position;
  final width;
  final height;
  Sprite sprite;

  Platform(this.sprite, this.position, this.width, this.height)
      : super(sprite, Vector2(width, height));
  @override
  Body createBody() {
    debugMode = false;
    debugColor = Color(0xff834f99);
    final shape = PolygonShape()..setAsBoxXY(width / 2, height / 2);
    final fixtureDef = FixtureDef(shape)
      ..userData = this
      // ..restitution = 0.8
      ..friction = 0;

    final bodyDef = BodyDef()
      ..userData = this // To be able to determine object in collision
      ..position = Vector2(position.x, position.y)
      ..type = BodyType.static;

    final platformworld = world.createBody(bodyDef);
    platformworld.createFixture(fixtureDef);

    return platformworld;
  }
}
