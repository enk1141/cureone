import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/mpin/mpin_bloc.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/main.dart';

class CreateMpinScreen extends StatefulWidget {
  const CreateMpinScreen({super.key});

  @override
  State<CreateMpinScreen> createState() => _CreateMpinScreenState();
}

class _CreateMpinScreenState extends State<CreateMpinScreen> with RouteAware {
  // 1 single controller for the MPIN row
  final TextEditingController _mpinController = TextEditingController();
  final FocusNode _mpinFocusNode = FocusNode();

  // 1 single controller for the confirmation MPIN row
  final TextEditingController _confirmController = TextEditingController();
  final FocusNode _confirmFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _mpinFocusNode.addListener(() {
      setState(() {});
    });
    _confirmFocusNode.addListener(() {
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
    // Returned from validate-MPIN — reset both rows so the user can re-enter.
    _clearAll();
  }

  void _clearAll() {
    _mpinController.clear();
    _confirmController.clear();
    if (mounted) {
      setState(() {});
      _mpinFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _mpinController.dispose();
    _mpinFocusNode.dispose();
    _confirmController.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  String _getMpin() => _mpinController.text;
  String _getConfirmMpin() => _confirmController.text;

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF0653C7);
    const Color accentTeal = Color(0xFF0653C7);
    const Color darkText = Color(0xFF0653C7);
    const Color lightBg = Colors.white;

    return Scaffold(
      backgroundColor: lightBg,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => MpinBloc(),
          child: BlocConsumer<MpinBloc, MpinState>(
            listener: (context, state) {
              if (state is MpinMismatch) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.redAccent),
                );
                for (var controller in [_confirmController]) {
                  controller.clear();
                }
                _confirmFocusNode.requestFocus();
              } else if (state is MpinSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("MPIN Created! Now verify it."),
                    backgroundColor: primaryTeal,
                  ),
                );

                // 🟢 FIX: Call your clean helper method instead of the null _controllers list
                String createdMpin = _getMpin();

                // Navigate to validation screen
                Navigator.pushNamed(
                  context,
                  AppRoutes.validateMpin,
                  arguments: createdMpin,
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
                      const SizedBox(height: 40),

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
                        "Create Security MPIN",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0653C7)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Set up a 4-digit MPIN for fast and secure logins",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                      ),
                      const SizedBox(height: 28),

                      // Main white card container
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ROW 1: Create MPIN
                            const Text(
                              "Enter 4-Digit MPIN",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: darkText),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                _mpinFocusNode.requestFocus();
                              },
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0,
                                    child: TextField(
                                      controller: _mpinController,
                                      focusNode: _mpinFocusNode,
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (val) {
                                        setState(() {});
                                        if (val.length == 4) {
                                          _confirmFocusNode.requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(4, (index) {
                                      final bool isFocused =
                                          _mpinFocusNode.hasFocus &&
                                          _mpinController.text.length == index;
                                      final bool hasText =
                                          index < _mpinController.text.length;

                                      return Container(
                                        height: 52,
                                        width: 52,
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
                                          hasText ? "•" : "",
                                          style: const TextStyle(
                                            fontSize: 28,
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
                            const SizedBox(height: 24),

                            // ROW 2: Re-enter MPIN
                            const Text(
                              "Confirm 4-Digit MPIN",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: darkText),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                _confirmFocusNode.requestFocus();
                              },
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0,
                                    child: TextField(
                                      controller: _confirmController,
                                      focusNode: _confirmFocusNode,
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (val) {
                                        setState(() {});
                                        if (val.length == 4) {
                                          context.read<MpinBloc>().add(
                                                SetMpinSubmitted(
                                                  mpin: _getMpin(),
                                                  confirmMpin: _getConfirmMpin(),
                                                ),
                                              );
                                        }
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(4, (index) {
                                      final bool isFocused =
                                          _confirmFocusNode.hasFocus &&
                                          _confirmController.text.length == index;
                                      final bool hasText =
                                          index < _confirmController.text.length;

                                      return Container(
                                        height: 52,
                                        width: 52,
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
                                          hasText ? "•" : "",
                                          style: const TextStyle(
                                            fontSize: 28,
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
                            const SizedBox(height: 32),

                            // Save Button
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
                                onPressed: state is MpinLoading
                                    ? null
                                    : () {
                                        context.read<MpinBloc>().add(
                                              SetMpinSubmitted(
                                                mpin: _getMpin(),
                                                confirmMpin: _getConfirmMpin(),
                                              ),
                                            );
                                      },
                                child: state is MpinLoading
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
                                          Icon(Icons.lock_outline,
                                              color: Colors.white, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            "Set MPIN",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Footer
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

  // Extracted input field box styling helper method
  InputDecoration _getInputDecoration(Color focusColor) {
    return InputDecoration(
      counterText: '',
      filled: true,
      fillColor: const Color(0xFFF4F6F9),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E9F2), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusColor, width: 2),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
