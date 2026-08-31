import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Features/ForgetPassword/View/forget_password_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../MainPage/View/main_home_page.dart';
import '../BLoC/auth_event.dart';
import '../BLoC/auth_bloc.dart';
import '../BLoC/auth_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController(
    text: "residential",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "123",
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/unit_bg.png',
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black.withOpacity(0.4)),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .25,
                                  child: Image.asset(
                                    "assets/images/aivio_logo_white.png",
                                    scale: 4,
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Your home, in hand...",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.8),
                                    letterSpacing: 1.1,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 4, child: Container()),
              ],
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "RESIDENT ACCESS",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: colors.textSecondary.withOpacity(0.8),
                              letterSpacing: 1.1,
                            ),
                          ),
                          Row(
                            children: [
                              _languageSwitcher("ع", true, colors),
                              const SizedBox(width: 8),
                              _languageSwitcher("EN", false, colors),
                              const SizedBox(width: 8),
                              _languageSwitcher("كر", false, colors),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Welcome home",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: colors.textMain,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Email or mobile", colors),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _usernameController,
                              decoration: _inputDecoration(
                                colors,
                                "ahmed@example.com",
                              ),
                              validator: (value) => value!.isEmpty
                                  ? "Please enter your email or mobile"
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _buildLabel("Password", colors),
                            const SizedBox(height: 6),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final bool isObscured = state.isPasswordVisible;
                                return TextFormField(
                                  controller: _passwordController,
                                  obscureText: isObscured,
                                  decoration: _inputDecoration(
                                    colors,
                                    "••••••••",
                                    suffixWidget: IconButton(
                                      icon: Icon(
                                        isObscured
                                            ? Icons.visibility_off_outlined
                                            : Icons.remove_red_eye_outlined,
                                        color: colors.textSecondary,
                                        size: 20,
                                      ),
                                      onPressed: () => context
                                          .read<AuthBloc>()
                                          .add(TogglePasswordVisibility()),
                                    ),
                                  ),
                                  validator: (value) => value!.length < 3
                                      ? "Password is too short"
                                      : null,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainHomePage(),
                              ),
                            );
                          } else if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          final bool isLoading = state is AuthLoading;

                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        context.read<AuthBloc>().add(
                                          LoginSubmitted(
                                            username: _usernameController.text,
                                            password: _passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      "Enter AIVIO",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordView(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontSize: 15,
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageSwitcher(String text, bool isSelected, AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? Colors.white
              : colors.textSecondary.withOpacity(0.3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? colors.primary : colors.textSecondary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildLabel(String text, AppColors colors) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(
        color: colors.textMain,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    ),
  );

  InputDecoration _inputDecoration(
    AppColors colors,
    String hint, {
    Widget? suffixWidget,
  }) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: colors.textSecondary.withOpacity(0.4),
      fontSize: 14,
    ),
    suffixIcon: suffixWidget,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.inputBorder.withOpacity(0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.primary, width: 1.5),
    ),
  );
}
