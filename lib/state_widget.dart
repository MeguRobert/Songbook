import 'package:flutter/material.dart';
import 'package:hello_word/models/song.dart';

class SongStateInheritedWidget extends InheritedWidget {
  final Song song;

  const SongStateInheritedWidget(
      {Key? key, required Widget child, required this.song})
      : super(key: key, child: child);

  static SongStateInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SongStateInheritedWidget>();

  @override
  bool updateShouldNotify(SongStateInheritedWidget oldWidget) {
    return oldWidget.song != song;
  }
}
