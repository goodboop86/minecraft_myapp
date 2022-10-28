import 'dart:math';

import 'package:fast_noise/fast_noise.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/structures.dart';
import 'package:minecraft/structures/trees.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../resources/biomes.dart';
import '../resources/blocks.dart';
import 'constants.dart';

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
    // chunkIndex: int 16,32,...の数だけ乱数を生成する
    // プレイヤーの移動に応じて配列が長くなるので良くない
    List<List<double>> rawNoise = noise2(
        chunkIndex >= 0
            ? chunkWidth * (chunkIndex + 1)
            : chunkWidth * (chunkIndex.abs()),
        1,
        noiseType: NoiseType.Perlin,
        frequency: 0.05,
        seed: chunkIndex >= 0
            ? GlobalGameReference.instance.gameReference.worldData.seed
            : GlobalGameReference.instance.gameReference.worldData.seed +
                10); //98765493

    // 乱数はdoubleなので、intに変換する
    List<int> yValues = getYValuesFromRawNoise(rawNoise);

    // 指定したchunkIndexに該当した乱数のみを取得する
    yValues.removeRange(
        0,
        chunkIndex >= 0
            ? chunkWidth * chunkIndex
            : chunkWidth * (chunkIndex.abs() - 1));

    chunk = generatePrimarySoil(chunk, yValues, biome);
    chunk = generateSecondarySoil(chunk, yValues, biome);
    chunk = generateStone(chunk);

    chunk = addStructureToChunk(chunk, yValues, biome);

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
    yValues.asMap().forEach((int index, int value) {
      for (int i = value + 1;
          i <= GameMethods.instance.maxSecondaryLoilExtent;
          i++) {
        chunk[i][index] = BiomeData.getBiomeDataFor(biome).secondarySoil;
      }
    });

    return chunk;
  }

  List<List<Blocks?>> generateStone(List<List<Blocks?>> chunk) {
    for (int index = 0; index < chunkWidth; index++) {
      for (int i = GameMethods.instance.maxSecondaryLoilExtent + 1;
          i < chunk.length;
          i++) {
        chunk[i][index] = Blocks.stone;
      }
    }

    int x1 = Random().nextInt(chunkWidth ~/ 2);
    int x2 = x1 + Random().nextInt(chunkWidth ~/ 2);

    chunk[GameMethods.instance.maxSecondaryLoilExtent]
        .fillRange(x1, x2, Blocks.stone);

    return chunk;
  }

  List<List<Blocks?>> addStructureToChunk(
      List<List<Blocks?>> chunk, List<int> yValues, Biomes biome) {
    BiomeData.getBiomeDataFor(biome)
        .generatingStructures
        .asMap()
        .forEach((key, Structure currentStructure) {
      // 配列のリンクの都合上、再度作成
      List<List<Blocks?>> structureList =
          List.from(currentStructure.structure.reversed);

      int xPositionOfSructure =
          Random().nextInt(chunkWidth - currentStructure.maxWidth);
      int yPositionOfStructure =
          (yValues[xPositionOfSructure + currentStructure.maxWidth ~/ 2]) - 1;

      for (int indexOfRow = 0;
          indexOfRow < currentStructure.structure.length;
          indexOfRow++) {
        List<Blocks?> rawOfBlocksInStructure = structureList[indexOfRow];

        rawOfBlocksInStructure
            .asMap()
            .forEach((int index, Blocks? blockInStructure) {
          if (chunk[yPositionOfStructure - indexOfRow]
                  [xPositionOfSructure + index] ==
              null) {
            chunk[yPositionOfStructure - indexOfRow]
                [xPositionOfSructure + index] = blockInStructure;
          }
        });
      }
    });
    return chunk;
  }

  List<int> getYValuesFromRawNoise(List<List<double>> rawNoise) {
    List<int> yValues = [];

    rawNoise.asMap().forEach((int index, List<double> value) {
      yValues
          .add((value[0] * 10).toInt().abs() + GameMethods.instance.freeArea);
    });

    return yValues;
  }
}
