import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'erase_restore.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EraseRestoreScreen(),
    );
  }
}

class EraseRestoreScreen extends StatefulWidget {
  const EraseRestoreScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EraseRestoreScreenState();
}

class _EraseRestoreScreenState extends State<EraseRestoreScreen> {
  double stokeWidth = 20;

  Future<EraseModel?> _getModel() async {
    final clipBuffer = await rootBundle.load('assets/images/clip.png');
    final clipImage =
        await decodeImageFromList(clipBuffer.buffer.asUint8List());

    final maskImageData =
        await EraseModel.getMaskImageData(clipBuffer.buffer.asUint8List());
    if (maskImageData == null) return null;
    return EraseModel(clipImage: clipImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<EraseModel?>(
            future: _getModel(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final data = snapshot.data;
              if (data == null) return const SizedBox.shrink();
              return EraseRestoreView(
                model: data,
                maskColor: const Color.fromARGB(74, 248, 13, 35),
              );
            },
          ),
        ],
      ),
    );
  }
}
