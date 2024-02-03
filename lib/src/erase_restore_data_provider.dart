import 'package:flutter/material.dart';

import 'models.dart';

class EraseRestoreData extends InheritedWidget {
  final List<EraseLinePath> lineList;
  final double strokeWidth;
  final List<EraseLinePath> restoreLineList;

  const EraseRestoreData({
    super.key,
    required this.lineList,
    required this.strokeWidth,
    required this.restoreLineList,
    required super.child,
  });

  static EraseRestoreData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EraseRestoreData>()!;
  }

  @override
  bool updateShouldNotify(EraseRestoreData oldWidget) {
    final strokeWidthNotEqual = oldWidget.strokeWidth != strokeWidth;
    final lineListNotEqual = oldWidget.lineList.hashCode != lineList.hashCode;
    final lineListLengthNotEqual = oldWidget.lineList.length != lineList.length;
    final shouldNotify =
        strokeWidthNotEqual || lineListNotEqual || lineListLengthNotEqual;
    return shouldNotify;
  }
}

class EraseRestoreDataProvider extends StatefulWidget {
  final Widget child;
  final void Function(bool enable)? previousStepEnable;
  final void Function(bool enable)? nextStepEnable;

  const EraseRestoreDataProvider({
    super.key,
    this.previousStepEnable,
    this.nextStepEnable,
    required this.child,
  });

  @override
  State<EraseRestoreDataProvider> createState() =>
      EraseRestoreDataProviderState();

  static State<EraseRestoreDataProvider> of(BuildContext context) {
    return context.findAncestorStateOfType<EraseRestoreDataProviderState>()!;
  }
}

class EraseRestoreDataProviderState extends State<EraseRestoreDataProvider> {
  List<EraseLinePath> _lineList = [];
  double _strokeWidth = 20;
  List<EraseLinePath> _restoreLineList = [];

  EraseLinePath _currentPath = EraseLinePath(drawPoints: []);

  void startEdit(Offset position) {
    _currentPath = EraseLinePath(
      drawPoints: [position],
      strokeWidth: _strokeWidth,
    );
    List<EraseLinePath> tempList = List.from(_lineList);
    tempList.add(_currentPath);
    _restoreLineList = [];
    setState(() {
      _lineList = tempList;
    });
  }

  void updateEdit(Offset position) {
    _currentPath.drawPoints.add(position);
    List<EraseLinePath> tempList = List.from(_lineList);
    tempList.last = _currentPath;
    setState(() {
      _lineList = tempList;
    });
  }

  void endEdit() {
    widget.previousStepEnable?.call(_lineList.isNotEmpty);
    widget.nextStepEnable?.call(_restoreLineList.isNotEmpty);
  }

  void previousStep() {
    final tempList = List<EraseLinePath>.from(_lineList);
    if (tempList.isEmpty) return;
    final lastItem = tempList.last;
    _restoreLineList.add(lastItem);
    tempList.removeLast();
    setState(() {
      _lineList = tempList;
    });
    endEdit();
  }

  void nextStep() {
    if (_restoreLineList.isEmpty) return;
    final lastItem = _restoreLineList.last;
    final tempList = List<EraseLinePath>.from(_lineList);
    tempList.add(lastItem);
    _restoreLineList.removeLast();
    setState(() {
      _lineList = tempList;
    });
    endEdit();
  }

  void updateStokeWidth(double width) {
    setState(() {
      _strokeWidth = width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return EraseRestoreData(
      lineList: _lineList,
      strokeWidth: _strokeWidth,
      restoreLineList: _restoreLineList,
      child: widget.child,
    );
  }
}
