import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minecraft/layout/game_layout.dart';
import 'package:minecraft/main_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    //許可する向きを指定する。
    DeviceOrientation.landscapeLeft, //左向きを許可
  ]);
  // runApp()ではあくまでWidgetを起動する必要がある
  runApp(const MaterialApp(home: GameLayout()));
}
