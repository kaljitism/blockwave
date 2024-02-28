import 'package:blockwave/components/player_component.dart';
import 'package:blockwave/global/global_game_reference.dart';
import 'package:blockwave/global/world_data.dart';
import 'package:flame/game.dart';
import 'package:get/get.dart';

class MainGame extends FlameGame {
  WorldData worldData;
  PlayerComponent playerComponent = PlayerComponent();
  GlobalGameReference globalGameReference = Get.put(GlobalGameReference());

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(playerComponent);
  }
}
