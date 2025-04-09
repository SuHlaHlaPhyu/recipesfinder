import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipefinder/presentation/main/bloc/main_bloc.dart';
import 'package:recipefinder/presentation/recipe/bloc/recipe_bloc.dart';

import '../../../core/di/app_di.dart';
import '../../main/view/main_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<MainBloc>()),
        BlocProvider(create: (context) => getIt<RecipeBloc>()),
      ],
      child: MaterialApp(
        title: 'Recipe Finder',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          );
        },
        home: const MainPage(),
      ),
    );
  }
}
