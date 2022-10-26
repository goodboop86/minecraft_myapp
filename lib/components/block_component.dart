import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../resources/blocks.dart';

class BlockComponent extends SpriteComponent {
  final Blocks block;

  BlockComponent({required this.block});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = GameMethods.instance.blockSize;
    sprite = await GameMethods.instance.getSpriteFromBlock(block);
  }
}
