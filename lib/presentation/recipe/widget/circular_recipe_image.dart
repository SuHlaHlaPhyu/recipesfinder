import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularRecipeImage extends StatelessWidget {
  final String imageUrl;
  const CircularRecipeImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorWidget:
            (context, url, error) => Container(
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported),
            ),
      ),
    );
  }
}
