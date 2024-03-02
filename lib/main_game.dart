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
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MainGame extends FlameGame {
  WorldData worldData;
  PlayerComponent playerComponent = PlayerComponent();
  GlobalGameReference globalGameReference = Get.put(GlobalGameReference());

  late Vector2 playerPosition;

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

    createWorldChunkFromChunkIndices(begin: -1, end: 1);
    worldData.chunksThatAreRendered.addAll([-1, 0, 1]);
    renderChunk([-1, 0, 1]);

    final gameCamera = CameraComponent(world: gameWorld);
    await add(gameCamera);
    gameCamera.follow(playerComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    worldData.chunksThatShouldBeRendered
        .asMap()
        .forEach((int index, int chunkIndex) {
      // Check if Chunk is not Rendered
      if (!worldData.chunksThatAreRendered.contains(chunkIndex)) {
        chunkIndex.isNegative
            ? renderLeftSideChunk(chunkIndex)
            : renderRightSideChunk(chunkIndex);
      }
    });
  }

  void renderRightSideChunk(chunkIndex) {
    if (worldData.rightWorldChunks[0].length ~/ chunkWidth < chunkIndex + 1) {
      GameMethods.instance.addToWorldChunks(
        chunk: ChunkGenerationMethods.instance.generateChunk(chunkIndex),
        isInRightWorld: true,
      );
    }
    renderIndividualChunk(chunkIndex);
    worldData.chunksThatAreRendered.add(chunkIndex);
  }

  void renderLeftSideChunk(chunkIndex) {
    if (worldData.leftWorldChunks[0].length ~/ chunkWidth < chunkIndex.abs()) {
      GameMethods.instance.addToWorldChunks(
        chunk: ChunkGenerationMethods.instance.generateChunk(chunkIndex),
        isInRightWorld: false,
      );
    }
    renderIndividualChunk(chunkIndex);
    worldData.chunksThatAreRendered.add(chunkIndex);
  }

  void createWorldChunkFromChunkIndices(
      {required int begin, required int end}) {
    for (int chunkIndex = begin; chunkIndex < end + 1; chunkIndex++) {
      GameMethods.instance.addToWorldChunks(
        chunk: ChunkGenerationMethods.instance.generateChunk(chunkIndex),
        isInRightWorld: chunkIndex >= 0,
      );
    }
  }

  void renderChunk(List<int> chunkIndices) {
    chunkIndices.isEmpty
        ? Intent.doNothing
        : chunkIndices.asMap().forEach(
            (key, value) {
              renderIndividualChunk(value);
            },
          );
    return;
  }

  void renderIndividualChunk(int chunkIndex) {
    List<List<Blocks?>> chunk = GameMethods.instance.getChunk(chunkIndex)!;

    chunk.asMap().forEach((yIndex, rowOfBlocks) {
      rowOfBlocks.asMap().forEach((xIndex, block) {
        if (block != null) {
          final component = BlockComponent(
            block: block,
            blockIndex: Vector2(
              (chunkIndex * chunkWidth) + xIndex.toDouble(),
              yIndex.toDouble(),
            ),
            chunkIndex: chunkIndex,
          );
          add(component);
          gameWorld.add(component);
        }
      });
    });
  }
}
