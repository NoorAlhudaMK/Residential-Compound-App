import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Image.asset(
                      'assets/images/aivio_residential_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "آيفيو - السكان",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors.textMain,
                    ),
                  ),
                  Text(
                    "نظام إدارة المجمع السكني",
                    style: TextStyle(fontSize: 14, color: colors.textSecondary),
                  ),

                  const SizedBox(height: 40),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مرحباً بعودتك",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: colors.textMain,
                          ),
                        ),
                        Text(
                          "سجّل دخولك للمتابعة",
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildLabel("اسم المستخدم", colors),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _usernameController,
                          decoration: _inputDecoration(
                            colors,
                            "أدخل اسم المستخدم",
                            Icons.person_outline,
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "يرجى إدخال اسم المستخدم" : null,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel("كلمة المرور", colors),
                        const SizedBox(height: 8),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final bool isObscured = state.isPasswordVisible;
                            return TextFormField(
                              controller: _passwordController,
                              obscureText: isObscured,
                              decoration: _inputDecoration(
                                colors,
                                "••••••••",
                                Icons.lock_outline,
                                suffixWidget: IconButton(
                                  icon: Icon(
                                    isObscured
                                        ? Icons.visibility_off_outlined
                                        : Icons.remove_red_eye_outlined,
                                  ),
                                  onPressed: () => context.read<AuthBloc>().add(
                                    TogglePasswordVisibility(),
                                  ),
                                ),
                              ),
                              validator: (value) => value!.length < 3
                                  ? "كلمة المرور قصيرة جداً"
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

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
                        // إظهار رسالة الخطأ للمستخدم (سواء خطأ سيرفر، إنترنت، أو بيانات خاطئة)
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
                      // التحقق مما إذا كانت الحالة هي تحميل
                      final bool isLoading = state is AuthLoading;

                      return SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          // إذا كان التطبيق في حالة تحميل، اجعل زر الضغط معطلاً (null) لكي لا يتكرر الطلب
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
                          // إذا كان التحميل جاريًا، اعرض دائرة التحميل، وإلا اعرض نص الزر
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
                                  "تسجيل الدخول",
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, AppColors colors) => Align(
    alignment: Alignment.centerRight,
    child: Text(
      text,
      style: TextStyle(color: colors.textMain, fontWeight: FontWeight.w600),
    ),
  );

  InputDecoration _inputDecoration(
    AppColors colors,
    String hint,
    IconData icon, {
    Widget? suffixWidget,
  }) => InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, color: colors.textSecondary),
    suffixIcon: suffixWidget,
    filled: true,
    fillColor: colors.inputFill,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: colors.inputBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: colors.primary),
    ),
  );
}
