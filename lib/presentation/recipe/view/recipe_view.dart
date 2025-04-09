import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipefinder/core/di/app_di.dart';
import 'package:recipefinder/presentation/recipe/bloc/recipe_bloc.dart';
import 'package:recipefinder/presentation/recipe/widget/recipe_widget.dart';

import '../../../core/data_sources/network/network_state.dart';

class RecipeView extends StatelessWidget {
  const RecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecipeBloc>(),
      child: BlocConsumer<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state.networkStatus == NetworkStatus.error) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(state.errorMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Recipe Finder')),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Recipes',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (input) {
                      context.read<RecipeBloc>().add(SearchRecipe(input));
                    },
                  ),
                ),
                if (state.networkStatus == NetworkStatus.loading)
                  const CircularProgressIndicator()
                else
                  Expanded(
                    child:
                        state.recipesList.isEmpty
                            ? Center(
                              child: Text(
                                'No results found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                            : GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 3 / 4.2,
                                  ),
                              itemCount: state.recipesList.length,
                              itemBuilder: (context, index) {
                                final recipe = state.recipesList[index];

                                return RecipeWidget(
                                  recipe: recipe,
                                  bottomWidget: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.thumb_up_alt_outlined,
                                            size: 16,
                                            color: Colors.grey[700],
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '${recipe.likes ?? 0}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          context.read<RecipeBloc>().add(
                                            ToggleFav(recipe),
                                          );
                                        },
                                        child: Icon(
                                          state.favRecipesList.any(
                                                (fav) => fav.id == recipe.id,
                                              )
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 23,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
