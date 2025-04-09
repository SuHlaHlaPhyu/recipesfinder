import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipefinder/core/constant/meal_type.dart';
import 'package:recipefinder/core/di/app_di.dart';
import 'package:recipefinder/presentation/recipe/bloc/recipe_bloc.dart';
import 'package:recipefinder/presentation/recipe/view/recipe_detail_view.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/helper/date_helper.dart';
import '../../../domain/model/meal_plan_entry.dart';
import '../widget/circular_recipe_image.dart';

class WeeklyMealPlanView extends StatelessWidget {
  const WeeklyMealPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecipeBloc>()..add(LoadWeeklyMealPlan()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new),
              ),
              const Text('Weekly Meal Plan'),
            ],
          ),
        ),
        body: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            final selectedDate = state.selectedDate;
            final selectedDay = DateHelper.dayFromDate(selectedDate);

            return Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 7)),
                  lastDay: DateTime.now().add(const Duration(days: 7)),
                  focusedDay: selectedDate,
                  calendarFormat: CalendarFormat.week,
                  headerVisible: false,
                  daysOfWeekVisible: true,
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    context.read<RecipeBloc>().add(
                      UpdateSelectedDate(selectedDay),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildSelectedDayMeals(context, state, selectedDay),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectedDayMeals(
    BuildContext context,
    RecipeState state,
    String selectedDay,
  ) {
    final meals = <String, MealPlanEntry>{};

    for (var entry in state.mealPlans.values) {
      if (entry.day == selectedDay) {
        meals[entry.mealType] = entry;
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            selectedDay,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ...mealTypes.map((mealType) {
          final entry = meals[mealType];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              onTap: () {
                if (entry != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => RecipeDetailView(recipe: entry.recipe),
                    ),
                  );
                }
              },
              title: Text(mealType),
              subtitle:
                  entry != null
                      ? Row(
                        children: [
                          CircularRecipeImage(
                            imageUrl: '${entry.recipe.image}',
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${entry.recipe.title}',
                              softWrap: true,
                            ),
                          ),
                        ],
                      )
                      : const Text('No meal planned'),
              trailing:
                  entry != null
                      ? IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<RecipeBloc>().add(
                            RemoveFromMealPlan(selectedDay, mealType),
                          );
                        },
                      )
                      : null,
            ),
          );
        }),
      ],
    );
  }
}
