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
import 'package:my_cure_ui/features/dashboard/screens/utility_details_screen.dart';
import 'package:my_cure_ui/features/dashboard/screens/pay_all_at_once_screen.dart';
import 'package:my_cure_ui/features/dashboard/screens/payment_confirmation_screen.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';

class AppRoutes {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String createMpin = '/create-mpin';
  static const String enterMpin = '/enter-mpin';
  static const String dashboard = '/dashboard';
  static const String utilityDetails = '/utility-details';
  static const String payAllAtOnce = '/pay-all-at-once';
  static const String paymentConfirmation = '/payment-confirmation';
static String get validateMpin => enterMpin;

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

      case utilityDetails:
        final udArgs = settings.arguments as Map<String, dynamic>;
        final udBloc = udArgs['bloc'] as DashboardBloc;
        final category = udArgs['category'] as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: udBloc,
            child: UtilityDetailsScreen(category: category),
          ),
          settings: settings,
        );

      case payAllAtOnce:
        final paoBloc = settings.arguments as DashboardBloc;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: paoBloc,
            child: const PayAllAtOnceScreen(),
          ),
          settings: settings,
        );

      case paymentConfirmation:
        final args = settings.arguments as Map<String, dynamic>;
        final selectedBills = args['selectedBills'] as List<Map<String, dynamic>>;
        final bloc = args['bloc'] as DashboardBloc;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: PaymentConfirmationScreen(selectedBills: selectedBills),
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
