import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipefinder/presentation/recipe/bloc/recipe_bloc.dart';
import 'package:recipefinder/presentation/recipe/widget/recipe_widget.dart';

import '../../../core/data_sources/network/network_state.dart';
import '../../../core/di/app_di.dart';

class FavoriteRecipeView extends StatelessWidget {
  const FavoriteRecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecipeBloc>()..add(GetFavorites()),
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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Favorite Recipe'),
            ),
            body:
                state.favRecipesList.isEmpty
                    ? Center(
                      child: Text(
                        'No Favorite found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
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
                      itemCount: state.favRecipesList.length,
                      itemBuilder: (context, index) {
                        final recipe = state.favRecipesList[index];
                        return RecipeWidget(
                          recipe: recipe,

                          bottomWidget: GestureDetector(
                            onTap: () {
                              context.read<RecipeBloc>().add(
                                ToggleFav(state.favRecipesList[index]),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${state.favRecipesList[index].title} removed from favorites',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: const Text(
                                  'Remove',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          );
        },
      ),
    );
  }
}
