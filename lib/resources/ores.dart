import 'package:minecraft/resources/blocks.dart';

class Ores {
  final Blocks block;
  final int rarity;

  Ores({required this.block, required this.rarity});

  static Ores ironOre = Ores(block: Blocks.ironOre, rarity: 100);
  static Ores coalOre = Ores(block: Blocks.coalOre, rarity: 100);
  static Ores goldOre = Ores(block: Blocks.goldOre, rarity: 65);
  static Ores diamondOre = Ores(block: Blocks.diamondOre, rarity: 50);
}
