import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/constants.dart';

class GameMethods {
  static GameMethods get instance {
    return GameMethods();
  }

  Vector2 get blockSize {
    // return Vector2.all(getScreenSize().width / chunkWidth);
    return Vector2.all(30);
  }

  int get freeArea {
    return (chunkHeight * 0.4).toInt();
  }

  int get maxSecondarySoilExtent {
    return freeArea + 6;
  }

  Size getScreenSize() {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  }

  double get playerXIndexPosition {
    return GlobalGameReference
            .instance.gameReference.playerComponent.position.x /
        blockSize.x;
  }

  int get currentChunkIndex {
    return playerXIndexPosition >= 0
        ? playerXIndexPosition ~/ chunkWidth
        : (playerXIndexPosition ~/ chunkWidth) - 1;
  }

  Vector2 getIndexPositionFromPixels(Vector2 clickPosition) {
    return Vector2((clickPosition.x / blockSize.x).floorToDouble(),
        (clickPosition.y / blockSize.y).floorToDouble());
  }

  double get gravity {
    return 0.8 * blockSize.y;
  }

  int getChunkIndexFromPositionIndex(Vector2 potitionIndex) {
    return potitionIndex.x ~/ chunkWidth;
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

  void addChunkToWorldChunks(
      List<List<Blocks?>> chunk, bool isInRightWorldChunks) {
    if (isInRightWorldChunks) {
      chunk.asMap().forEach((int yIndex, List<Blocks?> value) {
        GlobalGameReference
            .instance.gameReference.worldData.rightWorldChunks[yIndex]
            .addAll(value);
      });
    } else {
      chunk.asMap().forEach((int yIndex, List<Blocks?> value) {
        GlobalGameReference
            .instance.gameReference.worldData.leftWorldChunks[yIndex]
            .addAll(value);
      });
    }
  }

  List<List<Blocks?>> getChunk(int chunkIndex) {
    List<List<Blocks?>> chunk = [];

    // プレイヤーのインデックスが右側の場合
    if (chunkIndex >= 0) {
      GlobalGameReference.instance.gameReference.worldData.rightWorldChunks
          .asMap()
          .forEach((int index, List<Blocks?> rowOfBlocks) {
        // rightWorldChunksからchunkIndexに応じたスライスを取得
        chunk.add(rowOfBlocks.sublist(
            chunkWidth * chunkIndex, chunkWidth * (chunkIndex + 1)));
      });
    } else {
      GlobalGameReference.instance.gameReference.worldData.leftWorldChunks
          .asMap()
          .forEach((int index, List<Blocks?> rowOfBlocks) {
        chunk.add(rowOfBlocks
                .sublist(chunkWidth * (chunkIndex.abs() - 1),
                    chunkWidth * (chunkIndex.abs()))
                .reversed
                .toList()
            // 恐らく正しくない実装で本来は別seedのchunkが生成される想定
            // masterがreverseで実装しているので合わせる。
            );
      });
    }
    return chunk;
  }

  List<List<int>> processNoise(List<List<double>> rawNoise) {
    List<List<int>> processedNoise = List.generate(
      rawNoise.length,
      (index) => List.generate(rawNoise[0].length, (index) => 255),
    );

    for (var x = 0; x < rawNoise.length; x++) {
      for (var y = 0; y < rawNoise[0].length; y++) {
        var value = (0x80 + 0x80 * rawNoise[x][y]).floor(); // grayscale
        processedNoise[x][y] = value;
      }
    }
    return processedNoise;
  }
}
