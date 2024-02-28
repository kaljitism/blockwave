import 'package:blockwave/resources/block.dart';
import 'package:blockwave/utils/constants.dart';

class ChunkGenerationMethods {
  static ChunkGenerationMethods get instance {
    return ChunkGenerationMethods();
  }

  List<List<Blocks?>> generateNullChunk() {
    return List.generate(
      chunkHeight,
      (index) => List.generate(chunkWidth, (index) => null),
    );
  }

  List<List<Blocks?>> generateChunk() {
    List<List<Blocks?>> chunk = generateNullChunk();

    chunk.asMap().forEach((int indexOfRow, List<Blocks?> rowOfBlocks) {
      if (indexOfRow == 5) {
        rowOfBlocks.asMap().forEach((index, value) {
          chunk[5][index] = Blocks.grass;
        });
      }
      if (indexOfRow == 6) {
        rowOfBlocks.asMap().forEach((index, value) {
          chunk[6][index] = Blocks.dirt;
        });
      }
      if (indexOfRow >= 7) {
        rowOfBlocks.asMap().forEach((index, value) {
          chunk[indexOfRow][index] = Blocks.stone;
        });
      }
    });

    return chunk;
  }
}
