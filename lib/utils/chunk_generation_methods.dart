import 'package:blockwave/resources/block.dart';
import 'package:blockwave/utils/constants.dart';
import 'package:blockwave/utils/game_methods.dart';
import 'package:fast_noise/fast_noise.dart';

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

    List<List<double>> rawNoise = noise2(
      chunkWidth,
      1,
      noiseType: NoiseType.perlin,
      frequency: 0.05,
      seed: 999,
    );

    List<int> yValues = getYValueFromRawNoise(rawNoise);

    chunk = generatePrimarySoil(chunk, yValues, Blocks.grass);
    chunk = generateSecondarySoil(chunk, yValues, Blocks.dirt);

    return chunk;
  }

  List<List<Blocks?>> generatePrimarySoil(
    List<List<Blocks?>> chunk,
    List<int> yValues,
    Blocks block,
  ) {
    yValues.asMap().forEach((int index, int value) {
      chunk[value][index] = block;
    });
    return chunk;
  }

  List<List<Blocks?>> generateSecondarySoil(
    List<List<Blocks?>> chunk,
    List<int> yValues,
    Blocks block,
  ) {
    final int maxYExtent = GameMethods.instance.secondarySoilMaxExtent;
    yValues.asMap().forEach((int index, int value) {
      for (int i = value + 1; i <= maxYExtent; i++) {
        chunk[i][index] = block;
      }
    });
    return chunk;
  }

  List<int> getYValueFromRawNoise(List<List<double>> rawNoise) {
    List<int> yValues = [];

    rawNoise.asMap().forEach((int index, List<double> noise) {
      yValues
          .add((noise[0] * 10).toInt().abs() + GameMethods.instance.freeArea);
    });

    return yValues;
  }
}
