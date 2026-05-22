import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/mpin/mpin_bloc.dart';
import 'package:my_cure_ui/config/routes.dart';

class EnterMpinLoginScreen extends StatefulWidget {
  final String mobileNumber;
  const EnterMpinLoginScreen({super.key, required this.mobileNumber});

  @override
  State<EnterMpinLoginScreen> createState() => _EnterMpinLoginScreenState();
}

class _EnterMpinLoginScreenState extends State<EnterMpinLoginScreen> {
  final TextEditingController _mpinController = TextEditingController();
  final FocusNode _mpinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _mpinFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _mpinController.dispose();
    _mpinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF0653C7);
    const Color accentTeal = Color(0xFF0653C7);
    const Color darkText = Color(0xFF0653C7);

    return BlocProvider<MpinBloc>(
      create: (context) => MpinBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<MpinBloc, MpinState>(
            listener: (context, state) {
              if (state is LoginMpinSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.dashboard,
                  (route) => false,
                );
              } else if (state is LoginMpinFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.redAccent,
                  ),
                );

                _mpinController.clear();
                _mpinFocusNode.requestFocus();
              }
            },
            builder: (context, state) {
              final bool isLoading = state is MpinLoading;

              // 🟢 LayoutBuilder ensures the alignment centers perfectly relative to device screens
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                           padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 24),
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
                              const SizedBox(height: 30),
                              const Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0653C7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Enter your 4-digit security MPIN to log in",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14),
                              ),
                              const SizedBox(height: 32),
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
                                                enabled: !isLoading,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.digitsOnly
                                                ],
                                                onChanged: (val) {
                                                  setState(() {});
                                                  if (val.length == 4) {
                                                    context.read<MpinBloc>().add(
                                                          LoginMpinSubmitted(val),
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
                                                        BorderRadius.circular(14),
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
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, right: 4),
                                        child: TextButton(
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    AppRoutes.otp,
                                                    arguments: widget.mobileNumber,
                                                  );
                                                },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: const Text(
                                            "Forgot MPIN?",
                                            style: TextStyle(
                                              color: accentTeal,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF0653C7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                                String pin = _mpinController.text;
                                                if (pin.length == 4) {
                                                  context.read<MpinBloc>().add(
                                                      LoginMpinSubmitted(pin));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Please enter a complete 4-digit MPIN.",
                                                      ),
                                                      backgroundColor:
                                                          Colors.orange,
                                                    ),
                                                  );
                                                }
                                              },
                                        child: isLoading
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5,
                                                  ),
                                                )
                                            : const Text(
                                                "Unlock App",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}
