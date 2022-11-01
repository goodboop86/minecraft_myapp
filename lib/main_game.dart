import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/chunk_generation_methods.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

import 'components/player_component.dart';

class MainGame extends FlameGame with HasCollisionDetection {
  final WorldData worldData;

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  // GetXでどこでも参照できるようにする
  GlobalGameReference globalGameReference = Get.put(GlobalGameReference());
  PlayerComponent playerComponent = PlayerComponent();

  // onLoad: 初期化が終わったら実行
  @override
  Future<void> onLoad() async {
    super.onLoad();

    camera.followComponent(playerComponent);
    add(playerComponent);

    //初期ワールドを生成
    GameMethods.instance.addChunkToWorldChunks(
        ChunkGenerationMethods.instance.generateChunk(-1), false);
    GameMethods.instance.addChunkToWorldChunks(
        ChunkGenerationMethods.instance.generateChunk(0), true);
    GameMethods.instance.addChunkToWorldChunks(
        ChunkGenerationMethods.instance.generateChunk(1), true);
    renderChuck(-1);
    renderChuck(0);
    renderChuck(1);
  }

  void renderChuck(int chunkIndex) {
    // worldChunkからchunkIndexに応じた範囲のchunkを取得
    List<List<Blocks?>> chunk = GameMethods.instance.getChunk(chunkIndex);

    // chunkにBlockを詰める
    chunk.asMap().forEach((int yIndex, List<Blocks?> rowOfBlocks) {
      rowOfBlocks.asMap().forEach((int xIndex, Blocks? block) {
        if (block != null) {
          add(BlockComponent(
              block: block,
              blockIndex: Vector2(
                (chunkIndex * chunkWidth) + xIndex.toDouble(),
                yIndex.toDouble(),
              ),
              chunkIndex: chunkIndex));
        }
      });
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    worldData.chunksThatShouldBeRendered
        .asMap()
        .forEach((int index, int chunkIndex) {
      // Chunks isnt rendered
      if (!worldData.currentryRenderedChunks.contains(chunkIndex)) {
        // for rightWorldChunks
        if (chunkIndex >= 0) {
          // Chunks has not been rendered
          if (worldData.rightWorldChunks[0].length ~/ chunkWidth <
              chunkIndex + 1) {
            GameMethods.instance.addChunkToWorldChunks(
                ChunkGenerationMethods.instance.generateChunk(chunkIndex),
                true);
          }

          renderChuck(chunkIndex);

          worldData.currentryRenderedChunks.add(chunkIndex);

          // for leftWorldChunks
        } else {
          // Chunks has not been rendered
          if (worldData.leftWorldChunks[0].length ~/ chunkWidth <
              chunkIndex.abs()) {
            GameMethods.instance.addChunkToWorldChunks(
                ChunkGenerationMethods.instance.generateChunk(chunkIndex),
                false);
          }

          renderChuck(chunkIndex);

          worldData.currentryRenderedChunks.add(chunkIndex);
        }
      }
    });
  }
}
