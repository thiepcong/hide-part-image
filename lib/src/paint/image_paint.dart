import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../painter/image_painter.dart';

class ImagePaint extends StatelessWidget {
  final ui.Image image;
  final BlendMode blendMode;

  final Widget? child;
  const ImagePaint({
    Key? key,
    required this.image,
    this.blendMode = BlendMode.srcOver,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      isComplex: true,
      willChange: true,
      foregroundPainter: ImagePainter(
        image: image,
        blendMode: blendMode,
      ),
      child: child,
    );
  }
}
