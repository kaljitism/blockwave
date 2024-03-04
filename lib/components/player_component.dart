import 'package:blockwave/global/global_game_reference.dart';
import 'package:blockwave/global/player_data.dart';
import 'package:blockwave/global/world_data.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class PlayerComponent extends SpriteAnimationComponent {
  final Vector2 playerSize = Vector2(56, 95);
  final double playerSpeed = 5;
  final double idleStepTime = 0.5;
  final double walkingStepTime = 0.05;
  bool isFacingRight = true;
  final Vector2 playerInitialPosition = Vector2(100, 900);
  final playerPriority = 100;
  final anchorValue = Anchor.bottomCenter;

  late SpriteSheet playerWalkingSpriteSheet;
  late SpriteSheet playerIdleSpriteSheet;

  late SpriteAnimation idleAnimation =
      playerIdleSpriteSheet.createAnimation(row: 0, stepTime: idleStepTime);
  late SpriteAnimation walkingAnimation = playerWalkingSpriteSheet
      .createAnimation(row: 0, stepTime: walkingStepTime);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    position = playerInitialPosition;
    priority = playerPriority;
    anchor = anchorValue;

    Future<Image> idle =
        Flame.images.load('sprite_sheets/player/player_character_idle.png');
    Future<Image> walking =
        Flame.images.load('sprite_sheets/player/player_character_walking.png');

    playerIdleSpriteSheet = SpriteSheet(image: await idle, srcSize: playerSize);
    playerWalkingSpriteSheet =
        SpriteSheet(image: await walking, srcSize: playerSize);

    animation = idleAnimation;
  }

  @override
  void update(dt) {
    super.update(dt);
    movementLogic();
  }

  void movementLogic() {
    WorldData worldData = GlobalGameReference.instance.gameReference.worldData;
    bool idle =
        worldData.playerData.componentMotionState == ComponentMotionState.idle;
    bool walkingLeft = worldData.playerData.componentMotionState ==
        ComponentMotionState.walkingLeft;
    bool walkingRight = worldData.playerData.componentMotionState ==
        ComponentMotionState.walkingRight;

    if (idle) {
      animation = idleAnimation;
    }
    if (walkingLeft) {
      position.x -= playerSpeed;
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
      animation = walkingAnimation;
    }
    if (walkingRight) {
      position.x += playerSpeed;
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
      }
      animation = walkingAnimation;
    }
  }
}
