part of 'recipe_bloc.dart';

class RecipeState extends Equatable {
  final NetworkStatus networkStatus;
  final String errorMessage;
  final List<RecipeItem> recipesList;
  final List<RecipeItem> favRecipesList;
  final Map<String, MealPlanEntry> mealPlans;
  final DateTime selectedDate;
  final String selectedMealType;

  const RecipeState({
    this.networkStatus = NetworkStatus.initial,
    this.errorMessage = '',
    this.recipesList = const [],
    this.favRecipesList = const [],
    this.mealPlans = const {},
    required this.selectedDate,
    this.selectedMealType = 'Breakfast',
  });
  factory RecipeState.initial() {
    return RecipeState(selectedDate: DateTime.now());
  }
  RecipeState copyWith({
    NetworkStatus? networkStatus,
    bool? isError,
    String? errorMessage,
    List<RecipeItem>? recipesList,
    List<RecipeItem>? favRecipesList,
    DateTime? selectedDate,
    String? selectedMealType,

    Map<String, MealPlanEntry>? mealPlans,
  }) {
    return RecipeState(
      networkStatus: networkStatus ?? this.networkStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      recipesList: recipesList ?? this.recipesList,
      favRecipesList: favRecipesList ?? this.favRecipesList,
      mealPlans: mealPlans ?? this.mealPlans,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedMealType: selectedMealType ?? this.selectedMealType,
    );
  }

  @override
  List<Object?> get props => [
    networkStatus,
    errorMessage,
    recipesList,
    favRecipesList,
    mealPlans,
    selectedDate,
    selectedMealType,
  ];
}
