import 'package:compound/features/habit/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CompoundApp());
}

class CompoundApp extends StatelessWidget {
  const CompoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
