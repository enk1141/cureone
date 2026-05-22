import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/login/login_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/mpin/mpin_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/otp/otp_block.dart';
import 'package:my_cure_ui/features/auth/screens/login_screen.dart';
import 'package:my_cure_ui/features/auth/screens/otpscreen.dart';
import 'package:my_cure_ui/features/auth/screens/create_mpin_screen.dart';
import 'package:my_cure_ui/features/auth/screens/enter_mpin_screen.dart';
import 'package:my_cure_ui/features/auth/screens/validate_mpin_screen.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/features/dashboard/screens/utility_details_screen.dart';
import 'package:my_cure_ui/features/dashboard/screens/pay_all_at_once_screen.dart';
import 'package:my_cure_ui/features/shell/main_shell.dart';
import 'package:my_cure_ui/features/utilities/screens/my_utilities_screen.dart';
import 'package:my_cure_ui/features/utilities/screens/register_utility_screen.dart';
import 'package:my_cure_ui/features/payment/screens/payment_gateway_screen.dart';
import 'package:my_cure_ui/features/payment/screens/payment_success_screen.dart';
import 'package:my_cure_ui/features/payment/screens/payment_history_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String createMpin = '/create-mpin';
  static const String enterMpin = '/enter-mpin';
  static const String validateMpin = '/validate-mpin';
  static const String home = '/home';
  // Kept for backward compat — old callers that navigate to dashboard land on the shell.
  static const String dashboard = home;
  static const String utilityDetails = '/utility-details';
  static const String payAllAtOnce = '/pay-all-at-once';
  static const String myUtilities = '/my-utilities';
  static const String registerUtility = '/register-utility';
  static const String paymentGateway = '/payment-gateway';
  static const String paymentSuccess = '/payment-success';
  static const String paymentHistory = '/payment-history';

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

      case validateMpin:
        final mpin = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => MpinBloc(),
            child: ValidateMpinScreen(mpin: mpin),
          ),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DashboardBloc()..add(LoadBills()),
            child: const MainShell(),
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

      case myUtilities:
        final bloc = settings.arguments as DashboardBloc;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: const MyUtilitiesScreen(),
          ),
          settings: settings,
        );

      case registerUtility:
        final bloc = settings.arguments as DashboardBloc;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: const RegisterUtilityScreen(),
          ),
          settings: settings,
        );

      case paymentGateway:
        final args = settings.arguments as Map<String, dynamic>;
        final selectedBills =
            args['selectedBills'] as List<Map<String, dynamic>>;
        final bloc = args['bloc'] as DashboardBloc;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: PaymentGatewayScreen(selectedBills: selectedBills),
          ),
          settings: settings,
        );

      case paymentSuccess:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(
            paidBills: args['paidBills'] as List<Map<String, dynamic>>,
            paymentMethod: args['paymentMethod'] as String,
            transactionId: args['transactionId'] as String,
          ),
          settings: settings,
        );

      case paymentHistory:
        return MaterialPageRoute(
          builder: (_) => const PaymentHistoryScreen(),
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
