import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/login/login_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/mpin/mpin_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/otp/otp_block.dart';
import 'package:my_cure_ui/features/auth/screens/login_screen.dart';
import 'package:my_cure_ui/features/auth/screens/otpscreen.dart';
import 'package:my_cure_ui/features/auth/screens/create_mpin_screen.dart';
import 'package:my_cure_ui/features/auth/screens/enter_mpin_screen.dart';
import 'package:my_cure_ui/features/dashboard/screens/dashboard.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';

class AppRoutes {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String createMpin = '/create-mpin';
  static const String enterMpin = '/enter-mpin';
  static const String dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LoginBloc(),
            child: const LoginScreen(),
          ),
          settings: settings,
        );

      case otp:
        final mobileNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OtpBloc(),
            child: OtpScreen(mobileNumber: mobileNumber),
          ),
          settings: settings,
        );

      case createMpin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => MpinBloc(),
            child: const CreateMpinScreen(),
          ),
          settings: settings,
        );

      case enterMpin:
        final mobileNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => MpinBloc(),
            child: EnterMpinLoginScreen(mobileNumber: mobileNumber),
          ),
          settings: settings,
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DashboardBloc(),
            child: const DashboardScreen(),
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
