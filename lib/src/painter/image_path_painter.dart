import 'package:flutter/material.dart';

import '../models.dart';
import '../path_draw.dart';

class ImagePathPainter extends CustomPainter {
  final List<EraseLinePath> canvasPaths;

  ImagePathPainter({
    required this.canvasPaths,
  });

  @override
  void paint(Canvas canvas, Size size) {
    PathDraw.paint(
      canvasPaths: canvasPaths,
      canvas: canvas,
      paintColor: Colors.black,
    );
  }

  @override
  bool shouldRepaint(covariant ImagePathPainter oldDelegate) =>
      canvasPaths.length != oldDelegate.canvasPaths.length ||
      canvasPaths.lastOrNull?.drawPoints.length !=
          oldDelegate.canvasPaths.lastOrNull?.drawPoints.length;
}
