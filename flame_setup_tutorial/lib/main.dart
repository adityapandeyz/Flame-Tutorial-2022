import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}

class MyGame extends FlameGame {
  SpriteComponent girl = SpriteComponent();
  SpriteComponent boy = SpriteComponent();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // girl.sprite = await loadSprite('girl.png');
    girl
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2(100, 100)
      ..y = 100;
    add(girl);

    boy
      ..sprite = await loadSprite('boy.png')
      ..size = Vector2(100, 100)
      ..y = 200;
    add(boy);
  }
}
