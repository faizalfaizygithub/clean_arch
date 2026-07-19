import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerBuilder extends StatefulWidget {
  final Permission permission;
  final WidgetBuilder onGranted;
  final Widget Function(BuildContext context, VoidCallback requestPermission)
      onDenied;
  final Widget Function(BuildContext context, VoidCallback openSettings)
      onPermanentlyDenied;
  final WidgetBuilder? onLoading;

  const PermissionHandlerBuilder({
    super.key,
    required this.permission,
    required this.onGranted,
    required this.onDenied,
    required this.onPermanentlyDenied,
    this.onLoading,
  });

  @override
  State<PermissionHandlerBuilder> createState() =>
      _PermissionHandlerBuilderState();
}

class _PermissionHandlerBuilderState extends State<PermissionHandlerBuilder>
    with WidgetsBindingObserver {
  late Future<PermissionStatus> _statusFuture;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _statusFuture = widget.permission.status;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recheckPermissionStatus();
    }
  }

  void _recheckPermissionStatus() {
    setState(() {
      _statusFuture = widget.permission.status;
    });
  }

  void _requestPermission() {
    setState(() {
      _statusFuture = widget.permission.request();
    });
  }

  void _openSettings() {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: _statusFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.onLoading?.call(context) ??
              const Center(child: CircularProgressIndicator());
        }

        final status = snapshot.data;

        switch (status) {
          case PermissionStatus.granted:
          case PermissionStatus.limited:
            return widget.onGranted(context);
          case PermissionStatus.denied:
            return widget.onDenied(context, _requestPermission);
          case PermissionStatus.permanentlyDenied:
          case PermissionStatus.restricted:
            return widget.onPermanentlyDenied(context, _openSettings);
          default:
            return widget.onDenied(context, _requestPermission);
        }
      },
    );
  }
}
