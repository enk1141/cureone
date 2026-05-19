import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/bloc/login_bloc.dart';
import 'package:my_cure_ui/bloc/mpin_bloc.dart';
import 'package:my_cure_ui/enter_mpin_screen.dart';
import 'package:my_cure_ui/otpscreen.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  // State variable to handle real-time validation locally or via bloc
  String? _validationError;

  @override
  void dispose() {
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
    const Color primaryTeal = Color(0xFF19B9B9); //
    const Color accentTeal = Color(0xFF24BDBD); //
    const Color darkText = Color(0xFF0B0B22); //
    const Color lightBg = Color(0xFFF4F9F9); //

    return Scaffold(
      backgroundColor: lightBg, //
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginOtpSent) {
              // NEW/UNREGISTERED USER: Route to OTP Verification Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OtpScreen(mobileNumber: _phoneController.text.trim()),
                ),
              );
            } else if (state is LoginExistingUserSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<MpinBloc>(
                    create: (context) =>
                        MpinBloc(), // Instantiates a fresh Bloc for this screen
                    child: EnterMpinLoginScreen(
                        mobileNumber: _phoneController.text.trim()),
                  ),
                ),
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
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(), //
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24), //
                child: Column(
                  children: [
                    const SizedBox(height: 50), //

                    // Logo Container
                    Container(
                      height: 90, //
                      width: 90, //
                      decoration: BoxDecoration(
                        color: Colors.white, //
                        borderRadius: BorderRadius.circular(24), //
                        border: Border.all(
                          color: const Color(0xFFE5DFFF), //
                          width: 1, //
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16), //
                        child: Image.asset(
                          "assets/logo.png", //
                          fit: BoxFit.contain, //
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), //

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
                        color: darkText, //
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
                            color: Colors.black.withOpacity(.03), //
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
                                  color: const Color(0xFFE8FAF7), //
                                  borderRadius: BorderRadius.circular(12), //
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.lock, //
                                      color: Color(0xFF28BFAF), //
                                      size: 13, //
                                    ),
                                    SizedBox(width: 4), //
                                    Text(
                                      "Secure", //
                                      style: TextStyle(
                                        color: Color(0xFF28BFAF), //
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
                                    : accentTeal,
                                width: 1.5, //
                              ),
                              borderRadius: BorderRadius.circular(16), //
                            ),
                            child: Row(
                              children: [
                                // Country Code
                                Container(
                                  margin: const EdgeInsets.all(6), //
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12), //
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F7F8), //
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
                                          color: accentTeal, //
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
                                      counterText: '', //
                                      border: InputBorder.none, //
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 4), //
                                      hintText: "Enter mobile number", //
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade400, //
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
                                backgroundColor: const Color(0xFF24C5C5), //
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16), //
                                ),
                                elevation: 0, //
                              ),
                              // Button becomes disabled if there's an active validation format failure
                              onPressed: state is LoginLoading ||
                                      _validationError != null
                                  ? null
                                  : () {
                                      if (_phoneController.text.trim().length ==
                                          10) {
                                        //
                                        context.read<LoginBloc>().add(
                                              LoginSubmitted(
                                                //
                                                _phoneController.text.trim(), //
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 30), //

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
                          color: Colors.grey.shade200, //
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, //
                        children: [
                          Icon(
                            Icons.verified_user, //
                            color: Color(0xFF1DB9A9), //
                            size: 18, //
                          ),
                          SizedBox(width: 8), //
                          Flexible(
                            //
                            child: Text(
                              "Secure • Encrypted • Official CURE ONE App", //
                              style: TextStyle(
                                fontWeight: FontWeight.w600, //
                                fontSize: 12, //
                                color: Color(0xFF3D3D4E), //
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
                        color: Colors.grey.shade400, //
                        fontSize: 12, //
                      ),
                    ),
                    const SizedBox(height: 24), //
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
