import 'package:flutter/material.dart';

class AppLoader extends StatefulWidget {
  final double size;
  final Color? outerColor;
  final Color? innerColor;
  final double strokeWidth;

  const AppLoader({
    super.key,
    this.size = 60.0,
    this.outerColor,
    this.innerColor,
    this.strokeWidth = 4.0,
  });

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> with TickerProviderStateMixin {
  late AnimationController _outerController;
  late AnimationController _innerController;

  @override
  void initState() {
    super.initState();

    // Outer circle animation (slower)
    _outerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Inner circle animation (faster, reverse direction)
    _innerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _outerController.dispose();
    _innerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outerColor = widget.outerColor ?? theme.primaryColor;
    final innerColor = widget.innerColor ?? theme.colorScheme.secondary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer circle
          AnimatedBuilder(
            animation: _outerController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _outerController.value * 2 * 3.14159,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: CircularProgressIndicator(
                    strokeWidth: widget.strokeWidth,
                    color: outerColor,
                    value: 0.7,
                  ),
                ),
              );
            },
          ),
          // Inner circle
          AnimatedBuilder(
            animation: _innerController,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_innerController.value * 2 * 3.14159,
                child: SizedBox(
                  width: widget.size * 0.6,
                  height: widget.size * 0.6,
                  child: CircularProgressIndicator(
                    strokeWidth: widget.strokeWidth * 0.8,
                    color: innerColor,
                    value: 0.5,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
