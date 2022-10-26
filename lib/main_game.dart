import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/chunk_generation_methods.dart';

import 'components/player_component.dart';

class MainGame extends FlameGame {
  final WorldData worldData;

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  GlobalGameReference globalGameReference = Get.put(GlobalGameReference());
  PlayerComponent playerComponent = PlayerComponent();

  // onLoad: 初期化が終わるまで待つ
  @override
  Future<void> onLoad() async {
    super.onLoad();

    camera.followComponent(playerComponent);
    add(playerComponent);
    renderChuck(ChunkGenerationMethods.instance.generateChunk());
  }

  void renderChuck(List<List<Blocks?>> chunk) {
    chunk.asMap().forEach((int yIndex, List<Blocks?> rowOfBlocks) {
      rowOfBlocks.asMap().forEach((int xIndex, Blocks? block) {
        if (block != null) {
          add(BlockComponent(
            block: block,
            blockIndex: Vector2(
              xIndex.toDouble(),
              yIndex.toDouble(),
            ),
          ));
        }
      });
    });
  }
}
