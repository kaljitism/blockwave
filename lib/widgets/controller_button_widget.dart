import 'package:blockwave/global/global_game_reference.dart';
import 'package:blockwave/global/player_data.dart';
import 'package:flutter/material.dart';

class ControllerButtonWidget extends StatefulWidget {
  final String path;
  final VoidCallback onTap;

  const ControllerButtonWidget({
    super.key,
    required this.path,
    required this.onTap,
  });

  @override
  State<ControllerButtonWidget> createState() => _ControllerButtonWidgetState();
}

class _ControllerButtonWidgetState extends State<ControllerButtonWidget> {
  bool onPressed = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            onPressed = true;
            widget.onTap();
          });
        },
        onTapUp: (_) {
          setState(() {
            onPressed = false;
            GlobalGameReference.instance.gameReference.worldData.playerData
                .componentMotionState = ComponentMotionState.idle;
          });
        },
        onTapCancel: () {
          setState(() {
            onPressed = false;
            GlobalGameReference.instance.gameReference.worldData.playerData
                .componentMotionState = ComponentMotionState.idle;
          });
        },
        child: Opacity(
          opacity: onPressed ? 0.5 : 0.8,
          child: SizedBox(
            height: size.width / 17,
            width: size.width / 17,
            child: Image.asset(widget.path),
          ),
        ),
      ),
    );
  }
}
