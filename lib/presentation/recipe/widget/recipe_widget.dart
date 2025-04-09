import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipefinder/domain/model/recipe_result_response.dart';

import '../view/recipe_detail_view.dart';

class RecipeWidget extends StatelessWidget {
  final RecipeItem recipe;
  final Widget bottomWidget;

  const RecipeWidget({
    super.key,
    required this.recipe,
    required this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDetailView(recipe: recipe)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top image section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: recipe.image ?? '',
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            ),

            // Title and bottom widget section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${recipe.title}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: double.infinity, child: bottomWidget),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
