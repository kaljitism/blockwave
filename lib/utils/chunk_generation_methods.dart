import 'dart:math';

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
    );

    List<int> yValues = getYValueFromRawNoise(rawNoise);

    List<Blocks> oreList = [
      Blocks.coalOre,
      Blocks.ironOre,
      Blocks.diamondOre,
      Blocks.goldOre,
    ];
    chunk = generatePrimarySoil(chunk, yValues, Blocks.grass);
    chunk = generateSecondarySoil(chunk, yValues, Blocks.dirt);
    chunk = generateBedRock(chunk, Blocks.stone);
    chunk = generateOre(chunk, oreList);

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
    final int maxSecondarySoilExtent =
        GameMethods.instance.secondarySoilMaxExtent;
    yValues.asMap().forEach((int index, int value) {
      for (int i = value + 1; i <= maxSecondarySoilExtent; i++) {
        chunk[i][index] = block;
      }
    });
    return chunk;
  }

  List<List<Blocks?>> generateBedRock(
    List<List<Blocks?>> chunk,
    Blocks block,
  ) {
    final int maxSecondarySoilExtent =
        GameMethods.instance.secondarySoilMaxExtent;
    for (int rowIndex = maxSecondarySoilExtent;
        rowIndex < chunkHeight;
        rowIndex++) {
      for (int columnIndex = 0; columnIndex < chunkWidth; columnIndex++) {
        chunk[rowIndex][columnIndex] = block;
      }
    }
    return chunk;
  }

  List<List<Blocks?>> generateOre(
    List<List<Blocks?>> chunk,
    List<Blocks> oreList,
  ) {
    final int maxSecondarySoilExtent =
        GameMethods.instance.secondarySoilMaxExtent;

    for (int rowIndex = maxSecondarySoilExtent;
        rowIndex < chunkHeight;
        rowIndex++) {
      int randomNumberOfOres = Random().nextInt(15);
      List<int> randomPlaces = List.generate(
          randomNumberOfOres, (index) => Random().nextInt(chunkWidth));

      randomPlaces.asMap().forEach((int index, int columnIndex) {
        int randomOreIndex = Random().nextInt(oreList.length);
        chunk[rowIndex][columnIndex] = oreList[randomOreIndex];
      });
    }
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
