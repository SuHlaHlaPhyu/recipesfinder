import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipefinder/domain/model/recipe_result_response.dart';

class RecipeDetailView extends StatelessWidget {
  final RecipeItem recipe;

  const RecipeDetailView({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                '${recipe.title}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipe.image != null)
                CachedNetworkImage(
                  imageUrl: '${recipe.image}',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: 250.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16.0),
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children:
                    recipe.usedIngredients!
                        .map(
                          (ingredient) => Chip(
                            label: Text('${ingredient.name}'),
                            backgroundColor: Colors.blueAccent.withOpacity(0.1),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Icon(Icons.thumb_up_alt_outlined),
                  const SizedBox(width: 8.0),
                  Text('${recipe.likes} Likes'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
