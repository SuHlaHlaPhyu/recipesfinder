import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:recipefinder/domain/model/meal_plan_entry.dart';

import '../core/constant/box_name.dart';
import '../core/data_sources/api_endpoints.dart';
import '../core/data_sources/network/network_service.dart';
import '../domain/model/recipe_result_response.dart';
import '../domain/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl({required this.apiService});
  final NetworkService apiService;
  final _cacheBox = Hive.box(RECIPE_CACHE_BOX_NAME);
  final _favBox = Hive.box(FAVORITE_BOX_NAME);
  final _mealPlanBox = Hive.box(MEAL_PLAN_BOX_NAME);

  @override
  Future<List<RecipeItem>> searchRecipes({
    required Map<String, dynamic> query,
  }) async {
    final now = DateTime.now();
    final searchKeywords = query['ingredients'] as String;

    final normalizedKeyword = searchKeywords.trim().toLowerCase();

    final cachedEntry = _cacheBox.get(normalizedKeyword);

    if (cachedEntry != null) {
      final lastFetched = DateTime.parse(cachedEntry['timestamp']);
      final isFresh = now.difference(lastFetched) < Duration(minutes: 30);

      if (isFresh) {
        final List<dynamic> cachedList = jsonDecode(cachedEntry['data']);
        return cachedList.map((json) => RecipeItem.fromJson(json)).toList();
      }
    }

    final response = await apiService.getCall(
      ApiEndpoints.SEARCH_RECIPES_ENDPOINT,
      query,
    );

    final decoded = List<Map<String, dynamic>>.from(response);

    _cacheBox.put(normalizedKeyword, {
      'data': jsonEncode(decoded),
      'timestamp': now.toIso8601String(),
    });

    return decoded.map((json) => RecipeItem.fromJson(json)).toList();
  }

  @override
  Future<void> toggleFavorites({required RecipeItem recipe}) async {
    final key = recipe.id.toString();
    if (_favBox.containsKey(key)) {
      _favBox.delete(key);
    } else {
      _favBox.put(key, jsonEncode(recipe.toJson()));
    }
  }

  @override
  Future<List<RecipeItem>> getFavoriteRecipes() async {
    return _favBox.values
        .map((item) => RecipeItem.fromJson(jsonDecode(item)))
        .toList();
  }

  @override
  MealPlanEntry? getMealPlan({required String day, required String mealType}) {
    final key = '${day}_$mealType';
    final json = _mealPlanBox.get(key);
    if (json != null) {
      return MealPlanEntry.fromJson(jsonDecode(json));
    }
    return null;
  }

  @override
  Future<List<MealPlanEntry>> getWeeklyPlan() async {
    return _mealPlanBox.values
        .map((json) => MealPlanEntry.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> setMealPlan({required MealPlanEntry entry}) async {
    final key = '${entry.day}_${entry.mealType}';
    await _mealPlanBox.put(key, jsonEncode(entry.toJson()));
  }

  @override
  Future<void> removeMealPlan({
    required String day,
    required String mealType,
  }) async {
    final key = '${day}_$mealType';
    await _mealPlanBox.delete(key);
  }
}
