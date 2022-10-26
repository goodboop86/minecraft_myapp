import 'package:flutter/material.dart';
import 'package:minecraft/widgets/controller_button_widget.dart';

class ControllerWidget extends StatelessWidget {
  const ControllerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Positioned(bottom:0, left:0, child:)でも可能
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          children: [
            ControllerButtonWidget(
              path: "assets/controller/left_button.png",
              onPressed: () {
                debugPrint("left pressed.");
              },
            ),
            ControllerButtonWidget(
              path: "assets/controller/center_button.png",
              onPressed: () {
                debugPrint("center pressed.");
              },
            ),
            ControllerButtonWidget(
              path: "assets/controller/right_button.png",
              onPressed: () {
                debugPrint("right pressed.");
              },
            ),
          ],
        ),
      ),
    );
  }
}
