import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/login/login_bloc.dart';
import 'package:my_cure_ui/features/auth/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MY CURE',
        theme: ThemeData(
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: const Color(0xFFF4FCFC),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}