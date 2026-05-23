import 'package:flutter/material.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global RouteObserver used by pin-input screens so they can clear their
/// fields when returning to focus (didPopNext from RouteAware).
final RouteObserver<PageRoute<dynamic>> appRouteObserver =
    RouteObserver<PageRoute<dynamic>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedMpin = prefs.getString('saved_mpin');
  final mobileNumber = prefs.getString('mobile_number');

  runApp(MyApp(
    hasMpin: savedMpin != null && savedMpin.isNotEmpty,
    mobileNumber: mobileNumber,
  ));
}

class MyApp extends StatelessWidget {
  final bool hasMpin;
  final String? mobileNumber;

  const MyApp({
    super.key,
    required this.hasMpin,
    this.mobileNumber,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cure One',
      theme: buildAppTheme(),
      navigatorObservers: [appRouteObserver],
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: hasMpin ? AppRoutes.enterMpin : AppRoutes.login,
    );
  }
}
