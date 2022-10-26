import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'components/player_component.dart';

class MainGame extends FlameGame {
  // onLoad: 初期化が終わるまで待つ
  @override
  Future<void> onLoad() async {
    add(PlayerComponent());
  }
}
