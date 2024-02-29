import 'package:blockwave/components/block_component.dart';
import 'package:blockwave/components/player_component.dart';
import 'package:blockwave/global/global_game_reference.dart';
import 'package:blockwave/global/world_data.dart';
import 'package:blockwave/resources/blocks.dart';
import 'package:blockwave/utils/chunk_generation_methods.dart';
import 'package:blockwave/utils/constants.dart';
import 'package:blockwave/utils/game_methods.dart';
import 'package:flame/components.dart';
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

    // renderChunk(ChunkGenerationMethods.instance.generateChunk());
    GameMethods.instance.addToRightWorldChunks(
        ChunkGenerationMethods.instance.generateChunk(0));
    GameMethods.instance.addToRightWorldChunks(
        ChunkGenerationMethods.instance.generateChunk(1));
    GameMethods.instance.addToRightWorldChunks(
        ChunkGenerationMethods.instance.generateChunk(2));

    renderChunk(0);
    renderChunk(1);
    renderChunk(2);

    final gameCamera = CameraComponent(world: gameWorld);
    await add(gameCamera);
    gameCamera.follow(playerComponent);
  }

  void renderChunk(int chunkIndex) {
    List<List<Blocks?>> chunk = GameMethods.instance.getChunk(chunkIndex);

    chunk.asMap().forEach((yIndex, rowOfBlocks) {
      rowOfBlocks.asMap().forEach((xIndex, block) {
        if (block != null) {
          final component = BlockComponent(
            block: block,
            blockIndex: Vector2((chunkIndex * chunkWidth) + xIndex.toDouble(),
                yIndex.toDouble()),
          );
          add(component);
          gameWorld.add(component);
        }
      });
    });
  }
}
