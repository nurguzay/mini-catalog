import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage =
        imageUrl.startsWith('https://') || imageUrl.startsWith('http://');

    Widget errorWidget(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) {
      return SizedBox(
        width: width,
        height: height,
        child: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: Colors.grey,
          ),
        ),
      );
    }

    if (imageUrl.isEmpty) {
      return errorWidget(context, 'Görsel adresi boş', null);
    }

    if (isNetworkImage) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorWidget,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;

          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    }

    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorWidget,
    );
  }
}
