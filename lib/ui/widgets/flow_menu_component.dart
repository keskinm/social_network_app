import 'package:flutter/material.dart';

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation, this.rightToLeft = true})
      : super(repaint: menuAnimation);

  bool rightToLeft;
  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final double offset = context.getChildSize(0)!.width;
    Offset origin =
        Offset(context.size.width - offset, context.size.height - offset);
    double dx;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * (i);
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          rightToLeft
              ? origin.dx - dx * menuAnimation.value
              : origin.dx - dx * menuAnimation.value,
          origin.dy,
          0,
        ),
      );
    }
  }
}

Widget flowMenuItem(
    {required IconData icon, required action, required BuildContext context}) {
  final double buttonDiameter = MediaQuery.of(context).size.height / 10;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: buttonDiameter / 20),
    child: RawMaterialButton(
      fillColor: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).primaryColor,
      shape: const CircleBorder(),
      constraints: BoxConstraints.tight(Size(buttonDiameter, buttonDiameter)),
      onPressed: action,
      child: Icon(
        icon,
        color: Colors.white,
        size: buttonDiameter / 2,
      ),
    ),
  );
}
