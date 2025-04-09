import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipefinder/presentation/app/view/app.dart';

import 'core/di/app_di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  await configureDependencies();
  runApp(const App());
}
