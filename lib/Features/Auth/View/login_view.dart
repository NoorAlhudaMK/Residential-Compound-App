import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Repository/dashboard_repository.dart';
import '../../Dashboard/BLoC/dashboard_bloc.dart';
import '../../Dashboard/BLoC/dashboard_event.dart';
import '../../Dashboard/View/dashboard_view.dart';
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
  final TextEditingController _usernameController = TextEditingController(text: "admin");
  final TextEditingController _passwordController = TextEditingController(text: "1234");

  final bool isDark = true;

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
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.shield_outlined, size: 50, color: colors.primary),
                ),
                const SizedBox(height: 20),
                Text(
                  "بوابة الأمن",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.textMain),
                ),
                const Text(
                  "بوابة موظفي الأمن لعام 2026",
                  style: TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 1.1),
                ),
                const SizedBox(height: 30),

                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                    border: Border(top: BorderSide(color: colors.primary, width: 5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("رقم الموظف", colors),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _usernameController,
                          style: TextStyle(color: colors.textMain),
                          decoration: _inputDecoration(colors, "أدخل رقمك الوظيفي...", Icons.person_outline),
                          validator: (value) => value!.isEmpty ? "يرجى إدخال الرقم" : null,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel("كلمة المرور", colors),
                        const SizedBox(height: 8),

                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (previous, current) => current is AuthInitial,
                          builder: (context, state) {
                            bool isObscured = true;
                            if (state is AuthInitial) {
                              isObscured = state.isPasswordVisible;
                            }

                            return TextFormField(
                              controller: _passwordController,
                              obscureText: isObscured,
                              style: TextStyle(color: colors.textMain),
                              decoration: _inputDecoration(
                                colors,
                                "••••••••",
                                Icons.lock_outline,
                                suffixWidget: IconButton(
                                  icon: Icon(
                                    isObscured
                                        ? Icons.visibility_off_outlined
                                        : Icons.remove_red_eye_outlined,
                                    color: colors.textSecondary,
                                  ),
                                  onPressed: () {
                                    context.read<AuthBloc>().add(TogglePasswordVisibility());
                                  },
                                ),
                              ),
                              validator: (value) => value!.isEmpty ? "يرجى إدخال كلمة المرور" : null,
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                        Text("هل نسيت كلمة المرور؟", style: TextStyle(color: colors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),

                        BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("مرحباً بك: ${state.guardName}")));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => DashboardBloc(DashboardRepository())..add(FetchDashboardData()),
                                    child: const DashboardView(),
                                  ),
                                ),
                              );
                            } else if (state is AuthFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red));
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthLoading) return Center(child: CircularProgressIndicator(color: colors.primary));

                            return SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  foregroundColor: isDark ? Colors.black : Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(LoginSubmitted(
                                        username: _usernameController.text,
                                        password: _passwordController.text
                                    ));
                                  }
                                },
                                child: const Text("تسجيل الدخول", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text("نظام إدارة أمن المجمع السكني", style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                Text("${DateTime.now().year} © All Rights Reserved AIVIO LTD", style: TextStyle(color: colors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, AppColors colors) {
    return Text(text, style: TextStyle(color: colors.textMain, fontSize: 14, fontWeight: FontWeight.w600));
  }

  InputDecoration _inputDecoration(AppColors colors, String hint, IconData icon, {Widget? suffixWidget}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.textSecondary.withOpacity(0.5), fontSize: 14),
      prefixIcon: Icon(icon, color: colors.textSecondary),
      suffixIcon: suffixWidget,
      filled: true,
      fillColor: colors.inputFill,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
    );
  }
}