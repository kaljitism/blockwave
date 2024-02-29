import 'package:blockwave/resources/block.dart';
import 'package:blockwave/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

class GameMethods {
  static GameMethods get instance {
    return GameMethods();
  }

  Vector2 get blockSize {
    // return Vector2.all(screenSize().width / chunkWidth);
    return Vector2.all(30);
  }

  int get freeArea {
    return (chunkHeight * 0.6).toInt();
  }

  int get secondarySoilMaxExtent {
    return (freeArea + 6);
  }

  Size screenSize() {
    return MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.single)
        .size;
  }

  Future<SpriteSheet> getSpriteSheet() async {
    return SpriteSheet(
      image: await Flame.images
          .load('sprite_sheets/blocks/block_sprite_sheet_with_water.png'),
      srcSize: Vector2.all(60),
    );
  }

  Future<Sprite> getSpriteFromBlock(Blocks block) async {
    SpriteSheet spriteSheet = await getSpriteSheet();
    Sprite sprite = spriteSheet.getSprite(0, block.index);
    return sprite;
  }
}
