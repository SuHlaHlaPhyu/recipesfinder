import 'package:recipefinder/domain/model/recipe_result_response.dart';

class MealPlanEntry {
  final String day; // e.g., "Monday"
  final String mealType; // e.g., "Lunch"
  final RecipeItem recipe;

  MealPlanEntry({
    required this.day,
    required this.mealType,
    required this.recipe,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'mealType': mealType,
    'recipe': recipe.toJson(),
  };

  factory MealPlanEntry.fromJson(Map<String, dynamic> json) {
    return MealPlanEntry(
      day: json['day'],
      mealType: json['mealType'],
      recipe: RecipeItem.fromJson(json['recipe']),
    );
  }
}
