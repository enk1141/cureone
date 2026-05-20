import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/dashboard/dashboard.dart';
import 'package:my_cure_ui/otpscreen.dart';

import 'bloc/mpin_bloc.dart';
import 'bloc/mpin_event.dart';
import 'bloc/mpin_state.dart';

class EnterMpinLoginScreen extends StatefulWidget {
  final String mobileNumber;
  const EnterMpinLoginScreen({super.key, required this.mobileNumber});

  @override
  State<EnterMpinLoginScreen> createState() => _EnterMpinLoginScreenState();
}

class _EnterMpinLoginScreenState extends State<EnterMpinLoginScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF19B9B9);
    const Color accentTeal = Color(0xFF24BDBD);
    const Color darkText = Color(0xFF0B0B22);

    return BlocProvider<MpinBloc>(
      create: (context) => MpinBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F9F9),
        body: SafeArea(
          child: BlocConsumer<MpinBloc, MpinState>(
            listener: (context, state) {
              if (state is LoginMpinSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardScreen()),
                  (route) => false,
                );
              } else if (state is LoginMpinFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.redAccent,
                  ),
                );

                for (var controller in _controllers) {
                  controller.clear();
                }
                _focusNodes[0].requestFocus();
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
                                      color: const Color(0xFFE5DFFF), width: 1),
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
                                  color: darkText,
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
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(4, (index) {
                                        return SizedBox(
                                          height: 52,
                                          width: 52,
                                          child: KeyboardListener(
                                            focusNode: FocusNode(),
                                            onKeyEvent: (KeyEvent event) {
                                              if (event is KeyDownEvent &&
                                                  event.logicalKey ==
                                                      LogicalKeyboardKey
                                                          .backspace) {
                                                if (_controllers[index]
                                                        .text
                                                        .isEmpty &&
                                                    index > 0) {
                                                  _focusNodes[index - 1]
                                                      .requestFocus();
                                                }
                                              }
                                            },
                                            child: TextField(
                                              controller: _controllers[index],
                                              focusNode: _focusNodes[index],
                                              enabled: !isLoading,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              obscureText: true,
                                              maxLength: 1,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: darkText,
                                              ),
                                              decoration: InputDecoration(
                                                counterText: '',
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                    color: accentTeal,
                                                    width: 2,
                                                  ),
                                                ),
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                              onChanged: (value) {
                                                if (value.isNotEmpty &&
                                                    index < 3) {
                                                  _focusNodes[index + 1]
                                                      .requestFocus();
                                                } else if (value.isEmpty &&
                                                    index > 0) {
                                                  _focusNodes[index - 1]
                                                      .requestFocus();
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      }),
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
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OtpScreen(
                                                        mobileNumber:
                                                            widget.mobileNumber,
                                                      ),
                                                    ),
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
                                              const Color(0xFF24C5C5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                                String pin = _controllers
                                                    .map((c) => c.text)
                                                    .join();
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
