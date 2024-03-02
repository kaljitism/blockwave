import 'package:blockwave/global/global_game_reference.dart';
import 'package:blockwave/global/world_data.dart';
import 'package:blockwave/resources/blocks.dart';
import 'package:blockwave/utils/game_methods.dart';
import 'package:flame/components.dart';

class BlockComponent extends SpriteComponent {
  final Blocks block;
  final Vector2 blockIndex;
  final int chunkIndex;

  BlockComponent({
    required this.block,
    required this.blockIndex,
    required this.chunkIndex,
  });

  WorldData worldData = GlobalGameReference.instance.gameReference.worldData;

  @override
  Future<void> onLoad() async {
    sprite = await GameMethods.instance.getSpriteFromBlock(block);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!worldData.chunksThatShouldBeRendered.contains(chunkIndex)) {
      removeFromParent();
      worldData.chunksThatAreRendered.remove(chunkIndex);
    }
  }

  @override
  void onGameResize(Vector2 newGameSize) {
    super.onGameResize(newGameSize);
    size = GameMethods.instance.blockSize;
    position = Vector2(
      GameMethods.instance.blockSize.x * blockIndex.x,
      GameMethods.instance.blockSize.y * blockIndex.y,
    );
  }
}
