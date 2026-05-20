import 'package:flutter/material.dart';
import 'package:my_cure_ui/config/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MY CURE',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF4FCFC),
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.login,
    );
  }
}