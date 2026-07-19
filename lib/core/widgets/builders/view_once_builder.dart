import 'package:clean_starter/core/services/kv/storage_service.dart';
import 'package:clean_starter/di/locator.dart';
import 'package:flutter/widgets.dart';

class ShowOnceBuilder extends StatefulWidget {
  final String featureKey;
  final Widget Function(BuildContext context, VoidCallback markAsShown) builder;
  final Widget? placeholder;

  const ShowOnceBuilder({
    super.key,
    required this.featureKey,
    required this.builder,
    this.placeholder,
  });

  @override
  State<ShowOnceBuilder> createState() => _ShowOnceBuilderState();
}

class _ShowOnceBuilderState extends State<ShowOnceBuilder> {
  late Future<bool> _hasBeenShownFuture;

  @override
  void initState() {
    super.initState();
    _checkIfShown();
  }

  void _checkIfShown() {
    _hasBeenShownFuture =
        getIt<StorageService>().getBool(widget.featureKey).then((value) {
      return value ?? false;
    });
  }

  void _markAsShown() {
    getIt<StorageService>().setBool(widget.featureKey, true);
    setState(() {
      _hasBeenShownFuture = Future.value(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasBeenShownFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return widget.placeholder ?? const SizedBox.shrink();
        }

        final hasBeenShown = snapshot.data!;
        if (hasBeenShown) {
          return widget.placeholder ?? const SizedBox.shrink();
        } else {
          return widget.builder(context, _markAsShown);
        }
      },
    );
  }
}
