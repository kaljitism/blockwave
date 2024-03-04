import 'package:blockwave/resources/blocks.dart';
import 'package:blockwave/resources/structures.dart';
import 'package:blockwave/structures/cactus.dart';
import 'package:blockwave/structures/trees.dart';

enum Biomes {
  desert,
  birchForest,
}

class BiomeData {
  final Blocks primarySoil;
  final Blocks secondarySoil;
  List<Structure> generatingStructure;

  BiomeData({
    required this.primarySoil,
    required this.secondarySoil,
    required this.generatingStructure,
  });

  factory BiomeData.getBiomeDataFor(Biomes biome) {
    switch (biome) {
      case Biomes.desert:
        return BiomeData(
            primarySoil: Blocks.sand,
            secondarySoil: Blocks.sand,
            generatingStructure: [cactus]);
      case Biomes.birchForest:
        return BiomeData(
            primarySoil: Blocks.grass,
            secondarySoil: Blocks.dirt,
            generatingStructure: [tree]);
    }
  }
}
