import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/auth/bloc/mpin/mpin_bloc.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/main.dart';

class ValidateMpinScreen extends StatefulWidget {
  final String mpin;

  const ValidateMpinScreen({super.key, required this.mpin});

  @override
  State<ValidateMpinScreen> createState() => _ValidateMpinScreenState();
}

class _ValidateMpinScreenState extends State<ValidateMpinScreen> with RouteAware {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) appRouteObserver.subscribe(this, route);
  }

  @override
  void didPopNext() {
    // We came back into focus after a child route popped — reset.
    _clearAll();
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _mpinController.dispose();
    _mpinFocusNode.dispose();
    super.dispose();
  }

  void _clearAll() {
    _mpinController.clear();
    if (mounted) {
      setState(() {});
      _mpinFocusNode.requestFocus();
    }
  }

  String get _enteredMpin => _mpinController.text;

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
              _mpinController.clear();
              _mpinFocusNode.requestFocus();
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
                                      }
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(4, (index) {
                                    final bool isFocused =
                                        _mpinFocusNode.hasFocus &&
                                        _mpinController.text.length == index;
                                    final bool hasText =
                                        index < _mpinController.text.length;

                                    return Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: isFocused
                                              ? accentTeal
                                              : const Color(0xFFE5E9F2),
                                          width: isFocused ? 2.0 : 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        hasText ? "•" : "",
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
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
