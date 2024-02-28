import 'package:blockwave/resources/block.dart';
import 'package:blockwave/utils/game_methods.dart';
import 'package:flame/components.dart';

class BlockComponent extends SpriteComponent {
  final Blocks block;

  BlockComponent({required this.block});

  @override
  Future<void> onLoad() async {
    size = GameMethods.instance.blockSize;
    sprite = await GameMethods.instance.getSpriteFromBlock(block);
  }
}
