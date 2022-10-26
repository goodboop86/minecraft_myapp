import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/layout/controller_widget.dart';

import '../main_game.dart';

class GameLayout extends StatelessWidget {
  // リダイレクトコンストラクタ
  const GameLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Stack: Widgetを重ねて表示する。
    return Stack(
      children: [
        // メインゲーム
        // GameWidget: gameをWidget化する。
        GameWidget(game: MainGame()),

        // 以下にに全てのHUDが来る
        const ControllerWidget()
      ],
    );
  }
}
