import 'model/meal_plan_entry.dart';
import 'model/recipe_result_response.dart';

abstract class RecipeRepository {
  Future<List<RecipeItem>> searchRecipes({required Map<String, dynamic> query});

  Future<void> toggleFavorites({required RecipeItem recipe});

  Future<List<RecipeItem>> getFavoriteRecipes();

  Future<void> setMealPlan({required MealPlanEntry entry});

  Future<void> removeMealPlan({required String day, required String mealType});

  MealPlanEntry? getMealPlan({required String day, required String mealType});

  Future<List<MealPlanEntry>> getWeeklyPlan();
}
