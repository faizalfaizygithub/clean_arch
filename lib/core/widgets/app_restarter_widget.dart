import 'package:flutter/material.dart';

class AppRestarterWidget extends StatefulWidget {

  const AppRestarterWidget({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  AppRestarterWidgetState createState() => AppRestarterWidgetState();

  static void restart(BuildContext context) {
    context.findAncestorStateOfType<AppRestarterWidgetState>()!.restartApp();
  }
}

class AppRestarterWidgetState extends State<AppRestarterWidget> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
