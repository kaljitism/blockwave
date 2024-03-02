import 'package:blockwave/global/player_data.dart';
import 'package:blockwave/resources/blocks.dart';
import 'package:blockwave/utils/constants.dart';
import 'package:blockwave/utils/game_methods.dart';
import 'package:flutter/material.dart';

class WorldData {
  final int seed;

  WorldData({required this.seed});

  PlayerData playerData = PlayerData();

  List<List<Blocks?>> rightWorldChunks =
      List.generate(chunkHeight, (index) => []);
  List<List<Blocks?>> leftWorldChunks =
      List.generate(chunkHeight, (index) => []);

  List<int> get chunksThatShouldBeRendered {
    double playerXIndexPosition = GameMethods.instance.playerXIndexPosition;
    int chunkIndex = playerXIndexPosition ~/ chunkWidth;
    playerXIndexPosition.isNegative ? chunkIndex -= 1 : Intent.doNothing;
    return [chunkIndex - 1, chunkIndex, chunkIndex + 1];
  }

  List<int> chunksThatAreRendered = [];
}
