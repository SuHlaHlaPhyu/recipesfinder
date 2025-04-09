import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:recipefinder/data/recipe_repository_impl.dart';
import 'package:recipefinder/domain/recipe_repository.dart';
import 'package:recipefinder/presentation/main/bloc/main_bloc.dart';
import 'package:recipefinder/presentation/recipe/bloc/recipe_bloc.dart';

import '../constant/box_name.dart';
import '../data_sources/network/network_service.dart';

GetIt getIt = GetIt.instance;

Future configureDependencies() async {
  getIt.registerLazySingleton<NetworkService>(() => NetworkService.instance());

  await Hive.openBox(RECIPE_CACHE_BOX_NAME);
  await Hive.openBox(FAVORITE_BOX_NAME);
  await Hive.openBox(MEAL_PLAN_BOX_NAME);

  ///`Repository`
  getIt.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(apiService: getIt()),
  );

  ///`Bloc`
  getIt.registerFactory<MainBloc>(() => MainBloc());
  getIt.registerFactory<RecipeBloc>(
    () => RecipeBloc(recipeRepository: getIt()),
  );
}
