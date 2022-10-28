import 'package:flame/components.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../resources/blocks.dart';

class BlockComponent extends SpriteComponent {
  final Blocks block;
  final Vector2 blockIndex;
  final int chunkIndex;

  BlockComponent(
      {required this.block,
      required this.blockIndex,
      required this.chunkIndex});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await GameMethods.instance.getSpriteFromBlock(block);
  }

  @override
  void onGameResize(Vector2 newGameSize) {
    super.onGameResize(newGameSize);
    size = GameMethods.instance.blockSize;
    position = Vector2(GameMethods.instance.blockSize.x * blockIndex.x,
        GameMethods.instance.blockSize.x * blockIndex.y);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!GlobalGameReference
        .instance.gameReference.worldData.chunksThatShouldBeRendered
        .contains(chunkIndex)) {
      removeFromParent();

      GlobalGameReference
          .instance.gameReference.worldData.currentryRenderedChunks
          .remove(chunkIndex);
    }
  }
}
