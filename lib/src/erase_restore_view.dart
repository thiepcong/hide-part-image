import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'erase_restore_data_provider.dart';
import 'models.dart';
import 'paint/image_erase_paint.dart';
import 'paint/image_paint.dart';

class EraseView extends StatelessWidget {
  final EraseModel model;

  const EraseView({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EraseRestoreDataProvider(
      child: EraseRestoreInheritedView(model: model),
    );
  }
}

class EraseRestoreInheritedView extends StatefulWidget {
  final EraseModel model;

  const EraseRestoreInheritedView({Key? key, required this.model})
      : super(key: key);

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

  double _ind = 0;

  @override
  Widget build(BuildContext context) {
    final eraseRestoreData = EraseRestoreData.of(context);
    return Column(
      children: [
        Slider(
          value: _ind,
          onChanged: (e) {
            setState(() {
              _ind = e;
            });
            final provider = _getProvider();
            provider?.updateStokeWidth(e);
          },
          min: 0,
          max: 100,
        ),
        FittedBox(
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
        ),
      ],
    );
  }
}
