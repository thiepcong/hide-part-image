import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'image_processor.dart';

class EraseLinePath {
  final List<Offset> drawPoints;
  final double strokeWidth;

  EraseLinePath({
    required this.drawPoints,
    this.strokeWidth = 20,
  });
}

class EraseModel {
  final ui.Image clipImage;

  EraseModel({required this.clipImage});

  static Future<ImageData?> getMaskImageData(Uint8List imageBytes) async {
    final maskImageData = await ImageProcessor.getImageProcessByRGBA(
      imageBytes: imageBytes,
      color: Colors.white,
    );
    return maskImageData;
  }
}

class ImageData {
  final ui.Image image;
  final Uint8List imageBytes;
  final double width;
  final double height;

  ImageData({
    required this.image,
    required this.imageBytes,
    required this.width,
    required this.height,
  });
}

extension ListNull<E> on List<E> {
  E? get lastOrNull => length > 0 ? last : null;
}
