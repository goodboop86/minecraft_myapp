import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/utils/constants.dart';

import '../resources/blocks.dart';

class WorldData {
  final int seed;

  WorldData({required this.seed});

  PlayerData playerData = PlayerData();

  List<List<Blocks?>> rightWorldChunks =
      List.generate(chunkHeight, (index) => []);

  List<List<Blocks?>> leftWorldChunks =
      List.generate(chunkHeight, (index) => []);
}
