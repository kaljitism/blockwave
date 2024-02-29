import 'package:blockwave/components/block_component.dart';
import 'package:blockwave/components/player_component.dart';
import 'package:blockwave/global/global_game_reference.dart';
import 'package:blockwave/global/world_data.dart';
import 'package:blockwave/resources/block.dart';
import 'package:blockwave/utils/chunk_generation_methods.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:get/get.dart';

class MainGame extends FlameGame {
  WorldData worldData;
  PlayerComponent playerComponent = PlayerComponent();
  GlobalGameReference globalGameReference = Get.put(GlobalGameReference());

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  final World gameWorld = World();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(playerComponent);

    await add(gameWorld);
    gameWorld.add(playerComponent);

    renderChunk(ChunkGenerationMethods.instance.generateChunk());
    final gameCamera = CameraComponent(world: gameWorld);
    await add(gameCamera);
    gameCamera.follow(playerComponent);
  }

  void renderChunk(List<List<Blocks?>> blocks) {
    blocks.asMap().forEach((yIndex, rowOfBlocks) {
      rowOfBlocks.asMap().forEach((xIndex, block) {
        if (block != null) {
          final component = BlockComponent(
            block: block,
            blockIndex: Vector2(xIndex.toDouble(), yIndex.toDouble()),
          );
          add(component);
          gameWorld.add(component);
        }
      });
    });
  }
}
