import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
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
  bool isCollidingTop = false;

  double localPlayerSpeed = 0;

  double jumpforce = 0;

  bool refreshSpeed = false;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    for (var indivisualIntersectionPont in intersectionPoints) {
      // player is collided with the ground
      if (indivisualIntersectionPont.y > (position.y - (size.y * 0.3)) &&
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              size.x * 0.4) {
        isCollidingBottom = true;
        yVelocity = 0;
      }

      // Top collision
      if (indivisualIntersectionPont.y < (position.y - (size.y * 0.75)) &&
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              size.x * 0.4 &&
          jumpforce > 0) {
        isCollidingTop = true;
      }

      // Horizontal collision
      if (indivisualIntersectionPont.y < (position.y - (size.y * 0.3))) {
        // right collision
        if (indivisualIntersectionPont.x > position.x) {
          isCollidingRight = true;
        } else {
          isCollidingLeft = true;
        }
      }
    }
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

    add(TimerComponent(
        period: 1,
        repeat: true,
        onTick: () {
          refreshSpeed = true;
        }));
  }

  @override
  void update(double dt) {
    super.update(dt);
    movementLogic(dt);

    fallingLogic(dt);
    jumpingLogic();
    setAllCollisionToFalse();

    if (jumpforce > 0) {
      position.y -= jumpforce;
      jumpforce -= GameMethods.instance.blockSize.x * 0.15;
      if (isCollidingTop) {
        // topに衝突判定があったらジャンプ速度を0にする
        jumpforce = 0;
      }
    }

    if (refreshSpeed) {
      // 秒間フレームレートに、移動速度を固定する
      localPlayerSpeed = (playerSpeed * GameMethods.instance.blockSize.x) * dt;
      refreshSpeed = false;
    }
  }

  void jumpingLogic() {
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
    isCollidingTop = false;
  }

  void move(ComponentMotionState componentMotionState, double dt) {
    switch (componentMotionState) {
      case ComponentMotionState.walkingLeft:
        if (!isCollidingLeft) {
          position.x -= localPlayerSpeed;
        }
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        break;
      case ComponentMotionState.walkingRight:
        if (!isCollidingRight) {
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

    if (GlobalGameReference.instance.gameReference.worldData.playerData
                .componentMotionState ==
            ComponentMotionState.jumping &&
        isCollidingBottom) {
      jumpforce = GameMethods.instance.blockSize.x * 0.6;
      //animation = idleAnimation;
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void onGameResize(Vector2 newGameSize) {
    super.onGameResize(newGameSize);
    size = GameMethods.instance.blockSize;
  }
}
