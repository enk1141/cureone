import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/otp/otp_block.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/main.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({super.key, required this.mobileNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with RouteAware {
  // 1 single controller for the entire OTP
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _otpFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) appRouteObserver.subscribe(this, route);
  }

  @override
  void didPopNext() {
    _clearAll();
  }

  void _clearAll() {
    _otpController.clear();
    if (mounted) {
      setState(() {});
      _otpFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  String _getCombinedCode() {
    return _otpController.text;
  }

  @override
  Widget build(BuildContext context) {
    // Exact matching palette from login screen
    const Color primaryTeal = Color(0xFF0653C7);
    const Color accentTeal = Color(0xFF0653C7);
    const Color darkText = Color(0xFF0653C7);
    const Color lightBg = Colors.white;

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0653C7), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => OtpBloc(),
          child: BlocConsumer<OtpBloc, OtpState>(
            listener: (context, state) {
              if (state is OtpFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.redAccent),
                );
              } else if (state is OtpSuccess) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.createMpin,
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Matching Clean Logo Badge
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: const Color(0xFFE5E9F2), width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Image.asset("assets/logo.png",
                              fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "CURE ONE",
                        style: TextStyle(
                          color: primaryTeal,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        "Verify Number",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0653C7)),
                      ),
                      const SizedBox(height: 8),

                      // Explicit confirmation pointer
                      Text(
                        "Enter the 6-digit code sent to\n+91 ${widget.mobileNumber}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            height: 1.4),
                      ),
                      const SizedBox(height: 32),

                      // Clean Content White Card Container
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // NEW UPDATED CODE:
                            GestureDetector(
                              onTap: () {
                                _otpFocusNode.requestFocus();
                              },
                              child: Stack(
                                children: [
                                  // Hidden TextField
                                  Opacity(
                                    opacity: 0,
                                    child: TextField(
                                      controller: _otpController,
                                      focusNode: _otpFocusNode,
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (val) {
                                        setState(() {});
                                        if (val.length == 6) {
                                          context
                                              .read<OtpBloc>()
                                              .add(OtpSubmitted(val));
                                        }
                                      },
                                    ),
                                  ),
                                  // Visual Boxes
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(6, (index) {
                                      final bool isFocused =
                                          _otpFocusNode.hasFocus &&
                                          _otpController.text.length == index;
                                      final bool hasText =
                                          index < _otpController.text.length;
                                          
                                      return Container(
                                        height: 52,
                                        width: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F6F9),
                                          border: Border.all(
                                            color: isFocused
                                                ? accentTeal
                                                : const Color(0xFFE5E9F2),
                                            width: isFocused ? 2.0 : 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          hasText
                                              ? _otpController.text[index]
                                              : "",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: darkText,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Submit Button Action Builder
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0653C7),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                                onPressed: state is OtpLoading
                                    ? null
                                    : () {
                                        final fullCode = _getCombinedCode();
                                        context
                                            .read<OtpBloc>()
                                            .add(OtpSubmitted(fullCode));
                                      },
                                child: state is OtpLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_circle_outline,
                                              color: Colors.white, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            "Verify & Proceed",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Clean Inline Resend Utility UI
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Didn't receive code? ",
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 13)),
                                TextButton(
                                  onPressed: () {
                                    // Trigger Resend logic
                                  },
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero),
                                  child: const Text(
                                    "Resend",
                                    style: TextStyle(
                                        color: accentTeal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Matches lower secure decoration footer layout
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE5E9F2)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_user,
                                color: Color(0xFF0653C7), size: 18),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "Secure • Encrypted • Official CureOne App",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF0653C7)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("Version 1.0.0",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12)),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
