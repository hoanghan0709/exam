import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

const _defaultSize = 32;

/// Widget hiển thị ảnh từ URL với blurhash placeholder.
/// Tự decode blurhash thành ui.Image nhỏ (32x32) để hiển thị nhanh,
/// sau đó dùng AnimatedSwitcher fade sang ảnh thật khi tải xong.
///
/// Ví dụ:
/// ```dart
/// CommonBlurHash(
///   hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
///   imageUrl: 'https://example.com/image.jpg',
///   fit: BoxFit.cover,
/// )
/// ```
class CommonBlurHash extends StatefulWidget {
  const CommonBlurHash({
    required this.hash,
    super.key,
    this.imageUrl,
    this.fit = BoxFit.cover,
    this.width = double.maxFinite,
    this.height = double.maxFinite,
    this.decodingWidth = _defaultSize,
    this.decodingHeight = _defaultSize,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOut,
    this.httpHeaders = const {},
    this.errorBuilder,
  }) : assert(decodingWidth > 0),
       assert(decodingHeight != 0);

  /// Blurhash string để hiển thị placeholder.
  final String hash;

  /// Chiều rộng của widget.
  final double? width;

  /// Chiều cao của widget.
  final double? height;

  /// URL ảnh cần tải.
  final String? imageUrl;

  /// Cách fit ảnh trong container.
  final BoxFit fit;

  /// Kích thước decode blurhash (nhỏ hơn = nhẹ hơn, mặc định 32px).
  final int decodingWidth;

  /// Kích thước decode blurhash (nhỏ hơn = nhẹ hơn, mặc định 32px).
  final int decodingHeight;

  /// Thời gian fade từ blurhash sang ảnh thật.
  final Duration duration;

  /// Đường cong animation fade.
  final Curve curve;

  /// HTTP headers cho request tải ảnh (ví dụ: bearer token).
  final Map<String, String> httpHeaders;

  /// Widget hiển thị khi tải ảnh thất bại.
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  State<CommonBlurHash> createState() => _CommonBlurHashState();
}

class _CommonBlurHashState extends State<CommonBlurHash> {
  late Future<ui.Image> _hashImage;

  @override
  void initState() {
    super.initState();
    _decodeHash();
  }

  @override
  void didUpdateWidget(CommonBlurHash oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hash != oldWidget.hash ||
        widget.decodingWidth != oldWidget.decodingWidth ||
        widget.decodingHeight != oldWidget.decodingHeight) {
      _decodeHash();
    }
  }

  void _decodeHash() {
    _hashImage = blurHashDecodeImage(
      blurHash: widget.hash,
      width: widget.decodingWidth,
      height: widget.decodingHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl == null) {
      return _buildBlurHash();
    }

    return Image.network(
      widget.imageUrl!,
      fit: widget.fit,
      headers: widget.httpHeaders,
      errorBuilder: widget.errorBuilder,
      width: widget.width,
      height: widget.height,
      loadingBuilder: (context, child, loadingProgress) {
        final loaded = loadingProgress == null;
        return AnimatedSwitcher(
          duration: widget.duration,
          switchInCurve: widget.curve,
          child: loaded
              ? child
              : _buildBlurHash(key: const ValueKey('blurhash')),
        );
      },
    );
  }

  Widget _buildBlurHash({Key? key}) {
    return FutureBuilder<ui.Image>(
      key: key,
      future: _hashImage,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.errorBuilder?.call(
                context,
                snapshot.error!,
                snapshot.stackTrace,
              ) ??
              const Icon(Icons.error);
        }
        if (snapshot.hasData) {
          return Image(
            image: _UiImageProvider(snapshot.data!),
            fit: widget.fit,
            height: widget.height,
            width: widget.width,
            errorBuilder: widget.errorBuilder,
          );
        }
        return const SizedBox();
      },
    );
  }
}

/// ImageProvider đơn giản wrap ui.Image đã decode từ blurhash.
class _UiImageProvider extends ImageProvider<_UiImageProvider> {
  final ui.Image image;

  const _UiImageProvider(this.image);

  @override
  Future<_UiImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    _UiImageProvider key,
    ImageDecoderCallback decode,
  ) => OneFrameImageStreamCompleter(Future.value(ImageInfo(image: image)));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _UiImageProvider && other.image == image;

  @override
  int get hashCode => image.hashCode;
}
