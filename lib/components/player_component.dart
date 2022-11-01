import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

class PlayerComponent extends SpriteAnimationComponent with CollisionCallbacks {
  final Vector2 playerDimensions = Vector2.all(60);
  final double stepTime = 0.3;
  //final double speed = 5;
  bool isFacingRight = true;
  double yVelocity = 0;

  late SpriteSheet playerWalkingSpriteSheet;
  late SpriteSheet playerIdleSpriteSheet;

  late SpriteAnimation walkingAnimation =
      playerWalkingSpriteSheet.createAnimation(row: 0, stepTime: stepTime);
  late SpriteAnimation idleAnimation =
      playerIdleSpriteSheet.createAnimation(row: 0, stepTime: stepTime);

  bool isCollidingBottom = false;
  bool isCollidingLeft = false;
  bool isCollidingRight = false;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    intersectionPoints.forEach((Vector2 indivisualIntersectionPont) {
      // player is collided with the ground
      if (indivisualIntersectionPont.y > (position.y - (size.y * 0.3)) &&
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              size.x * 0.4) {
        isCollidingBottom = true;
        yVelocity = 0;
      }

      if (indivisualIntersectionPont.y < (position.y - (size.y * 0.3))) {
        // right collision
        if (indivisualIntersectionPont.x > position.x) {
          isCollidingRight = true;
        } else {
          isCollidingLeft = true;
        }
      }
    });
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(RectangleHitbox());

    priority = 2;
    anchor = Anchor.bottomCenter;

    playerWalkingSpriteSheet = SpriteSheet(
        image: await Flame.images
            .load("sprite_sheets/player/player_walking_sprite_sheet.png"),
        srcSize: playerDimensions);

    playerIdleSpriteSheet = SpriteSheet(
        image: await Flame.images
            .load("sprite_sheets/player/player_idle_sprite_sheet.png"),
        srcSize: playerDimensions);

    position = Vector2(100, 200);

    animation = idleAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);
    movementLogic(dt);

    fallingLogic(dt);
    setAllCollisionToFalse();

    if (jumpforce > 0) {
      position.y -= jumpforce;
      jumpforce -= GameMethods.instance.blockSize.x * 0.15;
    }
  }

  void fallingLogic(double dt) {
    if (!isCollidingBottom) {
      // fpsによらず一定の重力で落ちるようにする
      if (yVelocity < (GameMethods.instance.gravity * dt) * 5) {
        position.y += yVelocity;
        yVelocity += GameMethods.instance.gravity * dt;
      } else {
        position.y += yVelocity;
      }
    }
  }

  void setAllCollisionToFalse() {
    isCollidingBottom = false;
    isCollidingLeft = false;
    isCollidingRight = false;
  }

  double jumpforce = 0;

  void move(ComponentMotionState componentMotionState, double dt) {
    switch (componentMotionState) {
      case ComponentMotionState.walkingLeft:
        if (!isCollidingLeft) {
          position.x -= (playerSpeed * GameMethods.instance.blockSize.x) * dt;
        }
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        break;
      case ComponentMotionState.walkingRight:
        if (!isCollidingLeft) {
          position.x += (playerSpeed * GameMethods.instance.blockSize.x) * dt;
        }
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        break;
      default:
        break;
    }
  }

  void movementLogic(double dt) {
    if (GlobalGameReference
            .instance.gameReference.worldData.playerData.componentMotionState ==
        ComponentMotionState.walkingLeft) {
      move(ComponentMotionState.walkingLeft, dt);

      animation = walkingAnimation;
    }

    if (GlobalGameReference
            .instance.gameReference.worldData.playerData.componentMotionState ==
        ComponentMotionState.walkingRight) {
      move(ComponentMotionState.walkingRight, dt);

      animation = walkingAnimation;
    }

    if (GlobalGameReference
            .instance.gameReference.worldData.playerData.componentMotionState ==
        ComponentMotionState.idle) {
      animation = idleAnimation;
    }

    if (GlobalGameReference
            .instance.gameReference.worldData.playerData.componentMotionState ==
        ComponentMotionState.jumping) {
      jumpforce = GameMethods.instance.blockSize.x * 0.6;
      //animation = idleAnimation;
    }
  }

  @override
  void onGameResize(Vector2 newGameSize) {
    super.onGameResize(newGameSize);
    size = GameMethods.instance.blockSize;
  }
}
