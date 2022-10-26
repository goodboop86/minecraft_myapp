import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/world_data.dart';

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
    add(PlayerComponent());
  }
}
