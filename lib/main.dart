import 'package:compound/features/habit/data/models/habit_model.dart';
import 'package:compound/features/habit/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(HabitModelAdapter());

  runApp(CompoundApp());
}

class CompoundApp extends StatelessWidget {
  const CompoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
