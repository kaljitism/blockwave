import 'package:blockwave/layout/controller_widget.dart';
import 'package:blockwave/main_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameLayout extends StatelessWidget {
  const GameLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget(game: MainGame()),
        const ControllerWidget(),
      ],
    );
  }
}
