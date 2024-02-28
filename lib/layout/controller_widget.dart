import 'package:blockwave/widgets/controller_button_widget.dart';
import 'package:flutter/material.dart';

class ControllerWidget extends StatelessWidget {
  const ControllerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 20,
      child: Row(
        children: [
          ControllerButtonWidget(
            path: 'assets/controller/left_button.png',
            onTap: () {},
          ),
          ControllerButtonWidget(
            path: 'assets/controller/center_button.png',
            onTap: () {},
          ),
          ControllerButtonWidget(
            path: 'assets/controller/right_button.png',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
