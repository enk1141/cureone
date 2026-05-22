import 'package:flutter/material.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/config/theme_cubit.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MY CURE',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF0F0720),
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.login,
=======
    return BlocConsumer<ThemeCubit, ThemeMode>(
      listenWhen: (prev, curr) => prev != curr,
      listener: (context, themeMode) {
        AppThemeManager.setTheme(themeMode);
        void rebuild(Element el) {
          el.markNeedsBuild();
          el.visitChildren(rebuild);
        }

        (context as Element).visitChildren(rebuild);
      },
      builder: (context, themeMode) {
        AppThemeManager.setTheme(themeMode);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cure One',
          theme: buildAppTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: themeMode,
          navigatorObservers: [appRouteObserver],
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: AppRoutes.login,
        );
      },
>>>>>>> Stashed changes
    );
  }
}