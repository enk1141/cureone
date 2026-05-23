import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:my_cure_ui/features/auth/bloc/login/login_bloc.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  // State variable to handle real-time validation locally or via bloc
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    if (value.isNotEmpty) {
      final firstDigit = int.tryParse(value[0]);
      if (firstDigit != null && firstDigit >= 0 && firstDigit <= 5) {
        setState(() {
          _validationError = "Mobile number must start with 6, 7, 8, or 9";
        });
      } else {
        setState(() {
          _validationError = null;
        });
      }
    } else {
      setState(() {
        _validationError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Custom Color Palette
    const Color primaryTeal = Color(0xFF0653C7); //
    const Color accentTeal = Color(0xFF0653C7); //
    const Color darkText = Color(0xFF0653C7); //
    const Color lightBg = Colors.white; //

    return Scaffold(
      backgroundColor: lightBg, //
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginOtpSent) {
              final phone = _phoneController.text.trim();
              SharedPreferences.getInstance().then((prefs) {
                prefs.setString('mobile_number', phone);
              });
              Navigator.pushNamed(
                context,
                AppRoutes.otp,
                arguments: phone,
              );
            } else if (state is LoginExistingUserSuccess) {
              final phone = _phoneController.text.trim();
              SharedPreferences.getInstance().then((prefs) {
                prefs.setString('mobile_number', phone);
              });
              Navigator.pushNamed(
                context,
                AppRoutes.enterMpin,
                arguments: phone,
              );
            }

            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                    const SizedBox(height: 20), //

                    // Logo Container
                    Container(
                      height: 70, //
                      width: 70, //
                      decoration: BoxDecoration(
                        color: Colors.white, //
                        borderRadius: BorderRadius.circular(18), //
                        border: Border.all(
                          color: const Color(0xFFE5E9F2), //
                          width: 1, //
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12), //
                        child: Image.asset(
                          "assets/logo.png", //
                          fit: BoxFit.contain, //
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), //

                    // App Name
                    const Text(
                      "CURE ONE", //
                      style: TextStyle(
                        color: primaryTeal, //
                        fontSize: 22, //
                        fontWeight: FontWeight.w800, //
                        letterSpacing: 2.5, //
                      ),
                    ),
                    const SizedBox(height: 24), //

                    // Welcome Header
                    const Text(
                      "Welcome back", //
                      style: TextStyle(
                        fontSize: 20, //
                        fontWeight: FontWeight.w700, //
                        color: Color(0xFF0653C7), //
                      ),
                    ),
                    const SizedBox(height: 8), //
                    Text(
                      "Sign in with your mobile number to continue", //
                      textAlign: TextAlign.center, //
                      style: TextStyle(
                        color: Colors.grey.shade600, //
                        fontSize: 14, //
                        fontWeight: FontWeight.w400, //
                      ),
                    ),
                    const SizedBox(height: 32), //

                    // Main Card Container
                    Container(
                      padding: const EdgeInsets.all(20), //
                      decoration: BoxDecoration(
                        color: Colors.white, //
                        borderRadius: BorderRadius.circular(28), //
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05), //
                            blurRadius: 20, //
                            offset: const Offset(0, 8), //
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, //
                        children: [
                          // Field Title & Secure Badge
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween, //
                            children: [
                              const Text(
                                "Mobile Number", //
                                style: TextStyle(
                                  fontWeight: FontWeight.w700, //
                                  fontSize: 14, //
                                  color: darkText, //
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10, //
                                  vertical: 5, //
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6F9), //
                                  borderRadius: BorderRadius.circular(12), //
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.lock, //
                                      color: Color(0xFF0653C7), //
                                      size: 13, //
                                    ),
                                    SizedBox(width: 4), //
                                    Text(
                                      "Secure", //
                                      style: TextStyle(
                                        color: Color(0xFF0653C7), //
                                        fontWeight: FontWeight.w600, //
                                        fontSize: 12, //
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14), //

                          // Text Input Container
                          Container(
                            height: 60, //
                            decoration: BoxDecoration(
                              border: Border.all(
                                // Changes border color to red if an validation error exists
                                color: _validationError != null
                                    ? Colors.redAccent
                                    : accentTeal.withOpacity(0.5),
                                width: 1.5, //
                              ),
                              borderRadius: BorderRadius.circular(16), //
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15), //
                              child: Row(
                                children: [
                                // Country Code
                                Container(
                                  margin: const EdgeInsets.all(6), //
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12), //
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F6F9), //
                                    borderRadius: BorderRadius.circular(12), //
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        "🇮🇳", //
                                        style: TextStyle(fontSize: 18), //
                                      ),
                                      SizedBox(width: 6), //
                                      Text(
                                        "+91", //
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700, //
                                          color: Color(0xFF0653C7), //
                                          fontSize: 15, //
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Input Field
                                // Input Field
                                Expanded(
                                  child: TextField(
                                    focusNode: _phoneFocusNode,
                                    controller: _phoneController, //
                                    keyboardType: TextInputType.phone, //
                                    maxLength: 10, //

                                    // --- ADD THIS LINE TO BLOCK SPACES AND ONLY ALLOW DIGITS ---
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],

                                    style: const TextStyle(
                                      fontSize: 16, //
                                      fontWeight: FontWeight.w600, //
                                      letterSpacing: 0.5, //
                                      color: darkText, //
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 11),
                                      hintText: "Enter mobile number", //
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade500, //
                                        fontSize: 15, //
                                        fontWeight: FontWeight.w400, //
                                      ),
                                    ),
                                    onChanged: (value) {
                                      _validateInput(value); //
                                      context.read<LoginBloc>().add(
                                            MobileNumberChanged(value), //
                                          );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            ), // Close ClipRRect
                          ),
                          if (_validationError != null) ...[
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                _validationError!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24), //

                          // Login Button
                          SizedBox(
                            width: double.infinity, //
                            height: 52, //
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0653C7), //
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16), //
                                ),
                                elevation: 0, //
                              ),
                              onPressed: state is LoginLoading ||
                                      _validationError != null
                                  ? null
                                  : () {
                                      final text = _phoneController.text.trim();
                                      if (text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Please enter mobile number"),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      } else if (text.length != 10) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Please enter a valid 10-digit mobile number"),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      } else {
                                        context.read<LoginBloc>().add(
                                              LoginSubmitted(
                                                text, //
                                              ),
                                            );
                                      }
                                    },
                              child: state is LoginLoading //
                                  ? const SizedBox(
                                      height: 24, //
                                      width: 24, //
                                      child: CircularProgressIndicator(
                                        color: Colors.white, //
                                        strokeWidth: 2.5, //
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center, //
                                      children: [
                                        Icon(Icons.arrow_forward,
                                            color: Colors.white, size: 20), //
                                        SizedBox(width: 8), //
                                        Text(
                                          "Login", //
                                          style: TextStyle(
                                            color: Colors.white, //
                                            fontSize: 16, //
                                            fontWeight: FontWeight.bold, //
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16), //

                          // Disclaimer Text
                          Center(
                            child: Text(
                              "ⓘ We'll send a 6-digit verification code", //
                              style: TextStyle(
                                color: Colors.grey.shade500, //
                                fontSize: 13, //
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), //

                          // --- OR ---
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 20), //

                          // Quick Pay Button
                          SizedBox(
                            width: double.infinity, //
                            height: 52, //
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF0653C7), width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16), //
                                ),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.quickPay,
                                  arguments: DashboardBloc(),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.flash_on, color: Color(0xFF0653C7), size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Quick Pay",
                                    style: TextStyle(
                                      color: Color(0xFF0653C7),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Secure Footer Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, //
                        vertical: 10, //
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white, //
                        borderRadius: BorderRadius.circular(30), //
                        border: Border.all(
                          color: const Color(0xFFE5E9F2), //
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, //
                        children: [
                          Icon(
                            Icons.verified_user, //
                            color: Color(0xFF0653C7), //
                            size: 18, //
                          ),
                          SizedBox(width: 8), //
                          Flexible(
                            //
                            child: Text(
                              "Secure • Encrypted • Official CureOne App", //
                              style: TextStyle(
                                fontWeight: FontWeight.w600, //
                                fontSize: 12, //
                                color: Color(0xFF0653C7), //
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16), //

                    // Version Label
                    Text(
                      "Version 1.0.0", //
                      style: TextStyle(
                        color: Colors.grey.shade500, //
                        fontSize: 12, //
                      ),
                    ),
                    const SizedBox(height: 24), //
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
