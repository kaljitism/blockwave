import 'package:blockwave/main_game.dart';
import 'package:get/get.dart';

class GlobalGameReference {
  late MainGame gameReference;

  static GlobalGameReference get instance {
    return Get.put(GlobalGameReference());
  }
}
