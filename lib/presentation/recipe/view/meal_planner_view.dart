import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipefinder/core/di/app_di.dart';
import 'package:recipefinder/presentation/recipe/bloc/recipe_bloc.dart';
import 'package:recipefinder/presentation/recipe/view/recipe_detail_view.dart';
import 'package:recipefinder/presentation/recipe/view/weekly_meal_plan_view.dart';
import 'package:recipefinder/presentation/recipe/widget/circular_recipe_image.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constant/meal_type.dart';
import '../../../core/data_sources/network/network_state.dart';
import '../../../core/helper/date_helper.dart';

class MealPlannerView extends StatelessWidget {
  const MealPlannerView({super.key});

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
          final currentDayName = DateHelper.dayFromDate(state.selectedDate);

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Meal Planner'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeeklyMealPlanView(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 7)),
                  lastDay: DateTime.now().add(const Duration(days: 7)),
                  focusedDay: state.selectedDate,
                  calendarFormat: CalendarFormat.week,
                  headerVisible: false,
                  daysOfWeekVisible: true,
                  selectedDayPredicate: (day) {
                    return isSameDay(state.selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    context.read<RecipeBloc>().add(
                      UpdateSelectedDate(selectedDay),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8,
                    children:
                        mealTypes.map((mealType) {
                          return ChoiceChip(
                            label: Text(mealType),
                            selected: state.selectedMealType == mealType,
                            onSelected:
                                (_) => context.read<RecipeBloc>().add(
                                  UpdateSelectedMealType(mealType),
                                ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                      state.favRecipesList.isEmpty
                          ? Text('Add Favorite Recipe first...!')
                          : Text('Choose a favorite recipe:'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.favRecipesList.length,
                    itemBuilder: (context, index) {
                      final recipe = state.favRecipesList[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailView(recipe: recipe),
                            ),
                          );
                        },
                        leading: CircularRecipeImage(
                          imageUrl: '${recipe.image}',
                        ),
                        title: Text('${recipe.title}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            context.read<RecipeBloc>()
                              ..add(
                                SetMealPlan(
                                  currentDayName,
                                  state.selectedMealType,
                                  recipe,
                                ),
                              )
                              ..add(LoadWeeklyMealPlan());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added to ${DateHelper.dayFromDate(state.selectedDate)} ${state.selectedMealType}',
                                ),
                              ),
                            );
                          },
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
