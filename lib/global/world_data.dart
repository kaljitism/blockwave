import 'package:blockwave/global/player_data.dart';
import 'package:blockwave/resources/blocks.dart';
import 'package:blockwave/utils/constants.dart';

class WorldData {
  final int seed;

  WorldData({required this.seed});

  PlayerData playerData = PlayerData();

  List<List<Blocks?>> rightWorldChunks =
      List.generate(chunkHeight, (index) => []);
  List<List<Blocks?>> leftWorldChunks =
      List.generate(chunkHeight, (index) => []);
}
