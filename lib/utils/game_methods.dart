import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/constants.dart';

class GameMethods {
  static GameMethods get instance {
    return GameMethods();
  }

  Vector2 get blockSize {
    return Vector2.all(getScreenSize().width / chunkWidth);
  }

  Size getScreenSize() {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  }

  Future<SpriteSheet> getBlockSpriteSheet() async {
    return SpriteSheet(
        image: await Flame.images
            .load("sprite_sheets/blocks/block_sprite_sheet.png"),
        srcSize: Vector2.all(60));
  }

  Future<Sprite> getSpriteFromBlock(Blocks block) async {
    SpriteSheet spriteSheet = await getBlockSpriteSheet();
    return spriteSheet.getSprite(0, block.index);
  }
}
