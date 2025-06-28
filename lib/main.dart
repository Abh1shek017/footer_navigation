import 'package:flutter/material.dart';
import '/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

///
/// Root widget of the application.
/// Sets up the theme, routes, and initial home screen.
///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Bottom Nav Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Base color scheme derived from green seed color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        // Example to set default font for whole app:
        // fontFamily: 'Roboto',
      ),
      // For larger projects, you can use named routes:
      // routes: {
      //   '/': (context) => const HomeScreen(),
      //   '/another': (context) => const AnotherScreen(),
      // },
      home: const HomeScreen(), // starting screen
    );
  }
}
