import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/mpin/mpin_bloc.dart';
import 'package:my_cure_ui/config/routes.dart';

class ValidateMpinScreen extends StatefulWidget {
  final String mpin;

  const ValidateMpinScreen({super.key, required this.mpin});

  @override
  State<ValidateMpinScreen> createState() => _ValidateMpinScreenState();
}

class _ValidateMpinScreenState extends State<ValidateMpinScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleInput(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      }
    }
  }

  void _handleBackspace(RawKeyEvent event, int index) {
    if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  String get _enteredMpin =>
      _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF0653C7);
    const Color accentTeal = Color(0xFF0653C7);
    const Color darkText = Color(0xFF0653C7);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: darkText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<MpinBloc, MpinState>(
          listener: (context, state) {
            if (state is MpinSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("MPIN verified successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboard,
                (route) => false,
              );
            } else if (state is MpinMismatch) {
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
            bool isLoading = state is MpinLoading;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFE5DFFF),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        ),
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
                    const SizedBox(height: 40),
                    const Text(
                      "Verify Your MPIN",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Re-enter your 4-digit MPIN to confirm",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              return SizedBox(
                                height: 60,
                                width: 60,
                                child: RawKeyboardListener(
                                  focusNode: FocusNode(),
                                  onKey: (event) =>
                                      _handleBackspace(event, index),
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    obscureText: true,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      color: darkText,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: accentTeal,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: primaryTeal,
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (value) {
                                      _handleInput(value, index);
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0653C7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              onPressed: isLoading || _enteredMpin.length < 4
                                  ? null
                                  : () {
                                      if (_enteredMpin == widget.mpin) {
                                        context.read<MpinBloc>().add(
                                              SetMpinSubmitted(
                                                mpin: widget.mpin,
                                                confirmMpin: widget.mpin,
                                              ),
                                            );
                                      } else {
                                        context.read<MpinBloc>().add(
                                              SetMpinSubmitted(
                                                mpin: widget.mpin,
                                                confirmMpin: _enteredMpin,
                                              ),
                                            );
                                      }
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check,
                                            color: Colors.white, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          "Verify",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              "Make sure the MPIN matches",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
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
