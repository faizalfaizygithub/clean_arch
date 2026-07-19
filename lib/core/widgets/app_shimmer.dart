import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });
  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.rounded({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  });

  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
    required this.shapeBorder,
  });

  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400],
          shape: shapeBorder,
        ),
      ),
    );
  }
}

class ShimmerLayout {
  static Widget listTile({
    double height = 60,
    double width = double.infinity,
    Color color = Colors.white,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) {
    return Container(
      height: height,
      width: width,
      color: color,
      padding: padding,
      child: Row(
        children: [
          const ShimmerWidget.circular(width: 50, height: 50),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) => ShimmerWidget.circular(
                    width: constraints.maxWidth * 0.4,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    height: 16,
                  ),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) => ShimmerWidget.circular(
                    width: constraints.maxWidth * 0.8,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    height: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget card({
    double height = 200,
    double width = double.infinity,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rounded(height: height * 0.6),
          const SizedBox(height: 16),
          const ShimmerWidget.rectangular(height: 20),
          const SizedBox(height: 8),
          ShimmerWidget.rectangular(height: 15, width: width * 0.7),
        ],
      ),
    );
  }

  static Widget grid({
    int crossAxisCount = 2,
    double mainAxisSpacing = 16,
    double crossAxisSpacing = 16,
    double childAspectRatio = 0.8,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => const ShimmerWidget.rounded(
        height: double.infinity,
      ),
      itemCount: crossAxisCount * 2,
    );
  }

  static Widget listView({
    int itemCount = 8,
    double spacing = 16,
    double height = 60,
    double borderRadius = 10.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 16),
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemCount: itemCount,
    );
  }
}
