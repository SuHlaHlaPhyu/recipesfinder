import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipefinder/presentation/recipe/view/favorite_recipe_view.dart';
import 'package:recipefinder/presentation/recipe/view/meal_planner_view.dart';
import 'package:recipefinder/presentation/recipe/view/recipe_view.dart';

import '../bloc/main_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _screens = const [
    RecipeView(),
    FavoriteRecipeView(),
    MealPlannerView(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select(
      (MainBloc bloc) => bloc.state.currentTabIndex,
    );

    return Scaffold(
      body: _screens[selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap:
            (value) =>
                context.read<MainBloc>().add(NavIndexChanged(index: value)),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.set_meal), label: 'Planner'),
        ],
      ),
    );
  }
}
