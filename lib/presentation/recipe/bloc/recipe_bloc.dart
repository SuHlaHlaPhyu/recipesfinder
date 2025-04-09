import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:recipefinder/core/data_sources/network/network_state.dart';
import 'package:recipefinder/domain/model/recipe_result_response.dart';
import 'package:recipefinder/domain/recipe_repository.dart';

import '../../../core/data_sources/api_endpoints.dart';
import '../../../domain/model/meal_plan_entry.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc({required this.recipeRepository}) : super(RecipeState.initial()) {
    on<SearchRecipe>(_searchRecipeByIngredient);
    on<ToggleFav>(_toggleToFavorite);
    on<GetFavorites>(_getFavorites);
    on<SetMealPlan>(_setMealPlan);
    on<RemoveFromMealPlan>(_removeFromMealPlan);
    on<LoadWeeklyMealPlan>(_loadWeeklyMealPlan);
    on<UpdateSelectedDate>((event, emit) {
      emit(state.copyWith(selectedDate: event.selectedDate));
    });

    on<UpdateSelectedMealType>((event, emit) {
      emit(state.copyWith(selectedMealType: event.mealType));
    });
  }
  final RecipeRepository recipeRepository;
  final Logger _logger = Logger();

  Future<void> _searchRecipeByIngredient(
    SearchRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    emit(state.copyWith(networkStatus: NetworkStatus.loading));
    try {
      final result = await recipeRepository.searchRecipes(
        query: {
          'apiKey': API_KEY,
          'ingredients': event.searchInputs,
          'number': '50',
        },
      );
      emit(
        state.copyWith(
          recipesList: result,
          networkStatus: NetworkStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(errorMessage: '$e', networkStatus: NetworkStatus.error),
      );
      _logger.e('$e');
    }
  }

  Future<void> _toggleToFavorite(
    ToggleFav event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      final updatedFavorites = List<RecipeItem>.from(state.favRecipesList);
      final isAlreadyFav = updatedFavorites.any(
        (item) => item.id == event.favItem.id,
      );

      if (isAlreadyFav) {
        updatedFavorites.removeWhere((item) => item.id == event.favItem.id);
      } else {
        updatedFavorites.add(event.favItem);
      }

      await recipeRepository.toggleFavorites(recipe: event.favItem);

      emit(
        state.copyWith(
          favRecipesList: updatedFavorites,
          networkStatus: NetworkStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(errorMessage: '$e', networkStatus: NetworkStatus.error),
      );
      _logger.e('$e');
    }
  }

  Future<void> _getFavorites(
    GetFavorites event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      final favorites = await recipeRepository.getFavoriteRecipes();
      emit(
        state.copyWith(
          favRecipesList: favorites,
          networkStatus: NetworkStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(errorMessage: '$e', networkStatus: NetworkStatus.error),
      );
      _logger.e('$e');
    }
  }

  Future<void> _setMealPlan(
    SetMealPlan event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      final entry = MealPlanEntry(
        day: event.day,
        mealType: event.mealType,
        recipe: event.selectedRecipe,
      );
      await recipeRepository.setMealPlan(entry: entry);

      final updatedPlans = Map<String, MealPlanEntry>.from(state.mealPlans)
        ..['${event.day}_${event.mealType}'] = entry;

      emit(state.copyWith(mealPlans: updatedPlans));
    } catch (e) {
      emit(
        state.copyWith(errorMessage: '$e', networkStatus: NetworkStatus.error),
      );
      _logger.e('$e');
    }
  }

  Future<void> _removeFromMealPlan(
    RemoveFromMealPlan event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      await recipeRepository.removeMealPlan(
        day: event.day,
        mealType: event.mealType,
      );
      final updatedMealPlans = Map<String, MealPlanEntry>.from(state.mealPlans);
      updatedMealPlans.remove('${event.day}_${event.mealType}');
      emit(state.copyWith(mealPlans: updatedMealPlans));
    } catch (e) {
      emit(
        state.copyWith(errorMessage: '$e', networkStatus: NetworkStatus.error),
      );
      _logger.e('Failed to remove meal plan: $e');
    }
  }

  Future<void> _loadWeeklyMealPlan(
    LoadWeeklyMealPlan event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      final List<MealPlanEntry> plans = await recipeRepository.getWeeklyPlan();
      final Map<String, MealPlanEntry> map = {
        for (var entry in plans) '${entry.day}_${entry.mealType}': entry,
      };

      emit(state.copyWith(mealPlans: map));
    } catch (e) {
      emit(
        state.copyWith(errorMessage: '$e', networkStatus: NetworkStatus.error),
      );
      _logger.e('Failed to load meal plan: $e');
    }
  }
}
