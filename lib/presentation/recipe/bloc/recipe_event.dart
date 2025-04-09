part of 'recipe_bloc.dart';

sealed class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class SearchRecipe extends RecipeEvent {
  final String searchInputs;

  const SearchRecipe(this.searchInputs);

  @override
  List<Object> get props => [searchInputs];
}

class ToggleFav extends RecipeEvent {
  final RecipeItem favItem;

  const ToggleFav(this.favItem);

  @override
  List<Object> get props => [favItem];
}

class GetFavorites extends RecipeEvent {}

class SetMealPlan extends RecipeEvent {
  final String day;
  final String mealType;
  final RecipeItem selectedRecipe;

  const SetMealPlan(this.day, this.mealType, this.selectedRecipe);
}

class LoadWeeklyMealPlan extends RecipeEvent {}

class RemoveFromMealPlan extends RecipeEvent {
  final String day;
  final String mealType;

  const RemoveFromMealPlan(this.day, this.mealType);
}

class UpdateSelectedDate extends RecipeEvent {
  final DateTime selectedDate;

  const UpdateSelectedDate(this.selectedDate);
}

class UpdateSelectedMealType extends RecipeEvent {
  final String mealType;

  const UpdateSelectedMealType(this.mealType);
}
