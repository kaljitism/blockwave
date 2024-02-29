import 'package:blockwave/resources/blocks.dart';
import 'package:blockwave/utils/game_methods.dart';
import 'package:flame/components.dart';

class BlockComponent extends SpriteComponent {
  final Blocks block;
  final Vector2 blockIndex;

  BlockComponent({
    required this.block,
    required this.blockIndex,
  });

  @override
  Future<void> onLoad() async {
    sprite = await GameMethods.instance.getSpriteFromBlock(block);
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
