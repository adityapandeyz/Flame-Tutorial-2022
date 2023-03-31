import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}

class MyGame extends FlameGame with HasTappables {
  SpriteComponent girl = SpriteComponent();
  SpriteComponent boy = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  SpriteComponent background2 = SpriteComponent();
  DialogButton dialogButton = DialogButton();
  final Vector2 buttonSize = Vector2(50.0, 50.0);
  final double characterSize = 100.0;
  bool turnAway = false;
  int dialogLevel = 0;
  int sceneLevel = 1;
  TextPaint dailogTextPaint = TextPaint(
      style: const TextStyle(
    fontSize: 20,
    color: Colors.white,
  ));
  bool isDialogButtonAdded = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final screenWidth = size[0];
    final screenHeight = size[1];
    const double textBoxHeight = 300;

    //setup background2
    background2
      ..sprite = await loadSprite('castle.jpg')
      ..size = Vector2(
        size[0],
        size[1] - textBoxHeight,
      );

    // load background
    add(
      background
        ..sprite = await loadSprite('wp5152418.jpg')
        ..size = Vector2(
          size[0],
          size[1] - textBoxHeight,
        ),
    );

    // load char
    // girl.sprite = await loadSprite('girl.png');
    girl
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..anchor = Anchor.topCenter;
    add(girl);

    boy
      ..sprite = await loadSprite('boy.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..x = screenWidth - characterSize
      ..anchor = Anchor.topCenter
      ..flipHorizontally();
    add(boy);

    dialogButton
      ..sprite = await loadSprite('next_button.png')
      ..size = buttonSize
      ..position =
          Vector2(size[0] - buttonSize[0] - 10, size[1] - buttonSize[1] - 10);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (girl.x < size[0] / 2 - 100) {
      girl.x += 30 * dt;
      if (girl.x > 30 && dialogLevel == 0) {
        dialogLevel = 1;
      }
      if (girl.x > 80 && dialogLevel == 1) {
        dialogLevel = 2;
      }
    } else if (turnAway == false && sceneLevel == 1) {
      boy.flipHorizontally();
      turnAway = true;
      if (dialogLevel == 2) {
        dialogLevel = 3;
      }
    }

    if (boy.x > size[0] / 2 - 50 && sceneLevel == 1) boy.x -= 30 * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    switch (dialogLevel) {
      case 1:
        dailogTextPaint.render(
          canvas,
          'Keiko: Ken, don\'t go...'
          ' You\'ll die',
          Vector2(10, size[1] - 250),
        );
        break;
      case 2:
        dailogTextPaint.render(
          canvas,
          'Ken: I must fight for our village.',
          Vector2(10, size[1] - 250),
        );
        break;
      case 3:
        dailogTextPaint.render(
          canvas,
          'Keiko: What about the baby?',
          Vector2(10, size[1] - 250),
        );
        if (!isDialogButtonAdded) {
          add(dialogButton);
          isDialogButtonAdded = true;
        }
        break;
    }
    switch (dialogButton.scene2Level) {
      case 1:
        sceneLevel = 2;
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 250, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dailogTextPaint.render(
          canvas,
          'Ken: Child? I did not know',
          Vector2(10, size[1] - 250),
        );
        if (turnAway) {
          boy.flipHorizontally();
          boy.x = boy.x + 150;
          turnAway = false;
          // change scene
          remove(background);
          remove(boy);
          remove(girl);
          add(background2);

          add(boy);
          add(girl);
        }
        break;
      case 2:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 250, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dailogTextPaint.render(
          canvas,
          'Keiko: Our child. Our Future',
          Vector2(10, size[1] - 250),
        );
        break;
      case 3:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 250, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dailogTextPaint.render(
          canvas,
          'Ken: My future will be through you.',
          Vector2(10, size[1] - 250),
        );
        break;
    }
  }
}

class DialogButton extends SpriteComponent with Tappable {
  int scene2Level = 0;

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      print('We will move to the next screen');
      scene2Level++;
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
