import 'package:blockwave/global/player_data.dart';
import 'package:blockwave/widgets/controller_button_widget.dart';
import 'package:flutter/material.dart';

import '../global/global_game_reference.dart';

class ControllerWidget extends StatelessWidget {
  const ControllerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PlayerData playerData =
        GlobalGameReference.instance.gameReference.worldData.playerData;

    return Positioned(
      bottom: 100,
      left: 20,
      child: Row(
        children: [
          ControllerButtonWidget(
            path: 'assets/controller/left_button.png',
            onTap: () {
              playerData.componentMotionState =
                  ComponentMotionState.walkingLeft;
            },
          ),
          ControllerButtonWidget(
            path: 'assets/controller/center_button.png',
            onTap: () {},
          ),
          ControllerButtonWidget(
            path: 'assets/controller/right_button.png',
            onTap: () {
              playerData.componentMotionState =
                  ComponentMotionState.walkingRight;
            },
          ),
        ],
      ),
    );
  }
}
