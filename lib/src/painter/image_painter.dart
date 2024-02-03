import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImagePainter extends CustomPainter {
  final ui.Image image;
  final BlendMode blendMode;

  ImagePainter({
    required this.image,
    this.blendMode = BlendMode.srcOver,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(
      image,
      Offset.zero,
      Paint()
        ..filterQuality = FilterQuality.high
        ..blendMode = blendMode,
    );
  }

  @override
  bool shouldRepaint(covariant ImagePainter oldDelegate) => true;
}
