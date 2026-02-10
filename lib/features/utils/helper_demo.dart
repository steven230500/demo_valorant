import 'package:flutter/cupertino.dart';

bool isMobile(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final double width = size.width;

  return width < 600;
}
