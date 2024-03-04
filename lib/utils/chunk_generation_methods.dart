import 'dart:math';

import 'package:blockwave/global/global_game_reference.dart';
import 'package:blockwave/resources/biomes.dart';
import 'package:blockwave/resources/blocks.dart';
import 'package:blockwave/resources/structures.dart';
import 'package:blockwave/utils/constants.dart';
import 'package:blockwave/utils/game_methods.dart';
import 'package:fast_noise/fast_noise.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';

import '../structures/trees.dart';

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

  List<List<Blocks?>> generateChunk(int chunkIndex) {
    Biomes biome = Random().nextBool() ? Biomes.desert : Biomes.birchForest;

    List<List<Blocks?>> chunk = generateNullChunk();

    List<List<double>> rawNoise = noise2(
      chunkIndex >= 0
          ? chunkWidth * (chunkIndex + 1)
          : chunkWidth * (chunkIndex.abs()),
      1,
      noiseType: NoiseType.perlin,
      frequency: 0.05,
      seed: !chunkIndex.isNegative
          ? GlobalGameReference.instance.gameReference.worldData.seed
          : GlobalGameReference.instance.gameReference.worldData.seed + 1,
    );

    List<int> yValues = getYValueFromRawNoise(rawNoise);

    chunkIndex >= 0
        ? yValues.removeRange(0, chunkWidth * chunkIndex)
        : yValues.removeRange(0, chunkWidth * (chunkIndex.abs() - 1));

    chunk = generatePrimarySoil(chunk, yValues, biome);
    chunk = generateSecondarySoil(chunk, yValues, biome);
    chunk = generateStructures(chunk, yValues, biome);
    chunk = generateBedRock(chunk, Blocks.stone);
    chunk = generateOre(chunk, oreList);
    if (biome == Biomes.birchForest) {
      chunk = generateWater(chunk, yValues);
      chunk = generateFlora(chunk, yValues, floraList);
    }
    if (biome == Biomes.desert) {
      chunk = generateFlora(chunk, yValues, [Blocks.deadBush]);
    }

    return chunk;
  }

  List<List<Blocks?>> generatePrimarySoil(
      List<List<Blocks?>> chunk, List<int> yValues, Biomes biome) {
    yValues.asMap().forEach((int index, int value) {
      chunk[value][index] = BiomeData.getBiomeDataFor(biome).primarySoil;
    });
    return chunk;
  }

  List<List<Blocks?>> generateSecondarySoil(
      List<List<Blocks?>> chunk, List<int> yValues, Biomes biome) {
    final int maxSecondarySoilExtent =
        GameMethods.instance.secondarySoilMaxExtent;
    yValues.asMap().forEach((int index, int value) {
      for (int i = value + 1; i <= maxSecondarySoilExtent; i++) {
        chunk[i][index] = BiomeData.getBiomeDataFor(biome).secondarySoil;
      }
    });
    return chunk;
  }

  List<List<Blocks?>> generateStructures(
      List<List<Blocks?>> chunk, List<int> yValues, Biomes biome) {
    BiomeData.getBiomeDataFor(biome)
        .generatingStructure
        .asMap()
        .forEach((key, Structure currentStructure) {
      List<List<Blocks?>> structureList =
          List.from(currentStructure.structure.reversed);

      for (int occurrence = 0;
          occurrence < currentStructure.maxOccurrences;
          occurrence++) {
        int xPosition = Random().nextInt((chunkWidth - tree.maxWidth - 1));
        int yPosition = yValues[xPosition + (structureList.length ~/ 2)] - 1;

        for (int indexOfRow = 0;
            indexOfRow < currentStructure.maxWidth;
            indexOfRow++) {
          List<Blocks?> rowOfBlocksInStructure = structureList[indexOfRow];
          rowOfBlocksInStructure.asMap().forEach((indexOfColumn, value) {
            if (chunk[yPosition - indexOfRow][xPosition + indexOfColumn] ==
                null) {
              chunk[yPosition - indexOfRow][xPosition + indexOfColumn] = value;
            }
          });
        }
      }
    });

    return chunk;
  }

  List<List<Blocks?>> generateBedRock(List<List<Blocks?>> chunk, Blocks block) {
    final int maxSecondarySoilExtent =
        GameMethods.instance.secondarySoilMaxExtent;
    for (int rowIndex = maxSecondarySoilExtent + 1;
        rowIndex < chunkHeight;
        rowIndex++) {
      for (int columnIndex = 0; columnIndex < chunkWidth; columnIndex++) {
        chunk[rowIndex][columnIndex] = block;
      }
    }

    // Creating Top Row of BedRock merged with secondary layer.
    int x1 = Random().nextInt(chunkWidth ~/ 2);
    int x2 = x1 + Random().nextInt(chunkWidth - x1);
    chunk[maxSecondarySoilExtent].fillRange(x1, x2, block);

    return chunk;
  }

  List<List<Blocks?>> generateOre(
      List<List<Blocks?>> chunk, List<Blocks> oreList) {
    final int maxSecondarySoilExtent =
        GameMethods.instance.secondarySoilMaxExtent;

    for (int rowIndex = maxSecondarySoilExtent + 1;
        rowIndex < chunkHeight;
        rowIndex++) {
      int randomNumberOfOres = Random().nextInt(15);
      List<int> randomPlaces = List.generate(
          randomNumberOfOres, (index) => Random().nextInt(chunkWidth));

      randomPlaces.asMap().forEach((int index, int columnIndex) {
        chunk[rowIndex][columnIndex] = oreList.random();
      });
    }
    return chunk;
  }

  List<List<Blocks?>> generateFlora(
    List<List<Blocks?>> chunk,
    List<int> yValues,
    List<Blocks> floraList,
  ) {
    int randomNumberOfFlora = 10 + Random().nextInt(50);
    List<int> randomPlaces =
        List.generate(randomNumberOfFlora, (index) => Random().nextInt(131));

    yValues.asMap().forEach((int index, int value) {
      randomPlaces.contains(index)
          ? chunk[value - 1][index] == null
              ? chunk[value - 1][index] = floraList.random()
              : Intent.doNothing
          : Intent.doNothing;
    });
    return chunk;
  }

  List<List<Blocks?>> generateWater(
    List<List<Blocks?>> chunk,
    List<int> yValues,
  ) {
    int topRow = yValues.reduce(min);
    int bottomRow = yValues.reduce(max);
    for (int row = topRow + 1; row <= bottomRow; row++) {
      for (int column = 0; column < chunkWidth; column++) {
        chunk[row][column] == null
            ? chunk[row][column] = Blocks.water
            : Intent.doNothing;
      }
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
