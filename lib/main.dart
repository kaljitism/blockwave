import 'package:blockwave/layout/game_layout.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BlockWave());
}

class BlockWave extends StatelessWidget {
  const BlockWave({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameLayout(),
    );
  }
}
