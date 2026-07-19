import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

typedef ProgressIndicatorBuilder =
    Widget Function(
      BuildContext context,
      String url,
      DownloadProgress progress,
    );

class AppImageView extends StatelessWidget {
  final String imagePath;

  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;
  final Alignment alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;

  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  /// A placeholder widget to display while a network image is loading.
  final Widget? placeholder;

  /// An asset path for a fallback image to be shown in case of an error.
  final String errorPlaceholder;

  final Decoration? foregroundDecoration;
  final Duration fadeInDuration;
  final String? semanticLabel;
  final Function(Object, StackTrace?)? onError;

  /// Creates a standard AppImageView.
  const AppImageView(
    this.imagePath, {
    super.key,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.onTap,
    this.margin,
    this.radius,
    this.border,
    this.placeholder,
    this.foregroundDecoration,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.semanticLabel,
    this.onError,
    this.progressIndicatorBuilder,
    this.errorPlaceholder = 'assets/appImages/splaspic.png',
  });

  AppImageView.circular(
    this.imagePath, {
    super.key,
    this.height = 50,
    this.width = 50,
    this.color,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.onTap,
    this.margin,
    this.border,
    this.placeholder,
    this.foregroundDecoration,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.semanticLabel,
    this.onError,
    this.progressIndicatorBuilder,
    this.errorPlaceholder = 'assets/appImages/splaspic.png',
  }) : radius = BorderRadius.circular(height ?? 50 / 2);

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget = Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
        child: Align(alignment: alignment, child: _buildImage()),
      ),
    );

    if (semanticLabel != null) {
      return Semantics(label: semanticLabel, image: true, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildImage() {
    return Container(
      decoration: BoxDecoration(border: border, borderRadius: radius),
      foregroundDecoration: foregroundDecoration,
      clipBehavior: radius != null ? Clip.antiAlias : Clip.none,
      child: _buildImageView(),
    );
  }

  Widget _buildImageView() {
    if (imagePath.trim().isEmpty) {
      return _buildErrorWidget();
    }

    switch (imagePath.imageType) {
      case ImageType.svg:
        return _buildSvgImage();
      case ImageType.file:
        return _buildFileImage();
      case ImageType.lottie:
        return _buildLottieImage();
      case ImageType.network:
      case ImageType.networkSvg:
        return _buildNetworkImage();
      case ImageType.asset:
        return _buildAssetImage();
      case ImageType.unknown:
        log('Unknown image type: $imagePath');
        return _buildErrorWidget();
    }
  }

  Widget _buildSvgImage() {
    return SvgPicture.asset(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }

  Widget _buildFileImage() {
    return Image.file(
      File(imagePath),
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }

  Widget _buildLottieImage() {
    return Lottie.asset(imagePath, width: width, height: height, fit: fit);
  }

  Widget _buildAssetImage() {
    return Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }

  Widget _buildNetworkImage() {
    if (imagePath.imageType == ImageType.networkSvg) {
      return SvgPicture.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (context) =>
            placeholder ?? _buildDefaultPlaceholder(),
      );
    }

    return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit,
      imageUrl: imagePath,
      color: color,
      errorListener: (value) {},
      fadeInDuration: fadeInDuration,
      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
      progressIndicatorBuilder: progressIndicatorBuilder,
      errorWidget: (context, url, error) {
        onError?.call(error, StackTrace.current);
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildDefaultPlaceholder() {
    return SizedBox(
      height: 30,
      width: 30,
      child: LinearProgressIndicator(
        color: Colors.grey.shade200,
        backgroundColor: Colors.grey.shade100,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Image.asset(
      errorPlaceholder,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width,
          color: Colors.grey[300],
          child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
        );
      },
    );
  }
}

extension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      if (endsWith('.svg')) {
        return ImageType.networkSvg;
      }
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (endsWith('.json')) {
      return ImageType.lottie;
    } else if (startsWith('/') || startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.asset;
    }
  }
}

enum ImageType { network, networkSvg, file, asset, svg, lottie, unknown }
