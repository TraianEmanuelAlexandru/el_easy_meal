import 'package:el_easy_meal/ui/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:el_easy_meal/ui/screens/login.dart';
import 'package:el_easy_meal/ui/theme.dart';

class RecipesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes',
      theme: buildTheme(), // New code
      initialRoute: '/login',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}