import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'erase_restore_data_provider.dart';
import 'models.dart';
import 'paint/image_erase_paint.dart';
import 'paint/image_paint.dart';

class EraseRestoreView extends StatelessWidget {
  final EraseModel model;
  final Color maskColor;

  const EraseRestoreView({
    Key? key,
    required this.model,
    required this.maskColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EraseRestoreDataProvider(
      child: EraseRestoreInheritedView(
        model: model,
        maskColor: maskColor,
      ),
    );
  }
}

class EraseRestoreInheritedView extends StatefulWidget {
  final EraseModel model;
  final Color maskColor;

  const EraseRestoreInheritedView({
    Key? key,
    required this.model,
    required this.maskColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => EraseRestoreInheritedViewState();
}

class EraseRestoreInheritedViewState extends State<EraseRestoreInheritedView> {
  EraseModel get model => widget.model;
  EraseRestoreDataProviderState? _getProvider() {
    final eraseRestoreProvider = EraseRestoreDataProvider.of(context);
    if (eraseRestoreProvider is EraseRestoreDataProviderState) {
      return eraseRestoreProvider;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final eraseRestoreData = EraseRestoreData.of(context);
    return FittedBox(
      child: SizedBox(
        width: model.clipImage.width.toDouble(),
        height: model.clipImage.height.toDouble(),
        child: GestureDetector(
          onPanStart: (details) {
            final provider = _getProvider();
            provider?.startEdit(details.localPosition);
          },
          onPanUpdate: (details) {
            final provider = _getProvider();
            provider?.updateEdit(details.localPosition);
          },
          onPanEnd: (details) {
            final provider = _getProvider();
            provider?.endEdit();
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ui.ImageFilter.blur(),
                  blendMode: BlendMode.srcATop,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned.fill(
                        child: ImagePaint(
                          image: model.clipImage,
                        ),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(),
                          blendMode: BlendMode.dstOut,
                          child: ImageErasePaint(
                            canvasPaths: eraseRestoreData.lineList,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
