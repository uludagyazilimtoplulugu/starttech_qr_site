import 'package:flutter/widgets.dart';

class SpaceHelper {
  static Widget boslukHeight(context, double height) => SizedBox(
        height: MediaQuery.of(context).size.height * height,
      );

  static Widget boslukWidth(context, double width) => SizedBox(
        width: MediaQuery.of(context).size.width * width,
      );
}
