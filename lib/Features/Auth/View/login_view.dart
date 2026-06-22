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
  final TextEditingController _usernameController = TextEditingController(text: "7777777777");
  final TextEditingController _passwordController = TextEditingController(text: "1234");

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
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  // --- الشعار (Logo) ---
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primary.withOpacity(0.03),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Icon(
                            Icons.apartment_rounded,
                            size: 50,
                            color: colors.goldAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "مجمعي",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  Text(
                    "نظام إدارة المجمع السكني",
                    style: TextStyle(fontSize: 14, color: colors.textSecondary),
                  ),

                  const SizedBox(height: 15),
                  // --- نصوص الترحيب ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مرحباً بعودتك",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
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

                  const SizedBox(height: 30),
                  // --- نموذج تسجيل الدخول ---
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildLabel("رقم الهاتف", colors),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.phone,
                          textAlign: TextAlign.left, // للأرقام
                          decoration: _inputDecoration(
                            colors,
                            "7XX XXX XXXX",
                            Icons.phone_outlined,
                            isPhone: true,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildLabel("كلمة المرور", colors),
                        const SizedBox(height: 10),
                        // داخل TextFormField الخاص بكلمة المرور
                        BlocBuilder<AuthBloc, AuthState>(
                          // هنا نتأكد من إعادة البناء فقط عند تغير حالة الرؤية
                          buildWhen: (previous, current) {
                            if (previous is AuthInitial &&
                                current is AuthInitial) {
                              return previous.isPasswordVisible !=
                                  current.isPasswordVisible;
                            }
                            return true;
                          },
                          builder: (context, state) {
                            // نفترض أن الحالة الافتراضية هي الإخفاء (true)
                            bool isObscured = true;

                            if (state is AuthInitial) {
                              isObscured = state.isPasswordVisible;
                            }

                            return TextFormField(
                              controller: _passwordController,
                              obscureText: isObscured, // هذه هي النقطة المحورية
                              style: TextStyle(color: colors.textMain),
                              decoration: _inputDecoration(
                                colors,
                                "••••••••",
                                Icons.lock_outline,
                                suffixWidget: IconButton(
                                  // تغيير الأيقونة بناءً على الحالة
                                  icon: Icon(
                                    isObscured
                                        ? Icons.visibility_off_outlined
                                        : Icons.remove_red_eye_outlined,
                                    color: colors.textSecondary,
                                  ),
                                  onPressed: () {
                                    // إرسال الأيفينت للـ Bloc
                                    context.read<AuthBloc>().add(
                                      TogglePasswordVisibility(),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "نسيت كلمة المرور؟",
                              style: TextStyle(
                                color: colors.goldAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        // --- زر تسجيل الدخول ---
                        BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "مرحباً بك: ${state.guardName}",
                                  ),
                                ),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainHomePage(),
                                ),
                              );
                            } else if (state is AuthFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.errorMessage),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return CircularProgressIndicator(
                                color: colors.primary,
                              );
                            }
                            return SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      LoginSubmitted(
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // const SizedBox(height: 20),
                  // Text("أو", style: TextStyle(color: colors.textSecondary)),
                  // const SizedBox(height: 20),

                  // --- زر البصمة ---
                  // Container(
                  //   width: double.infinity,
                  //   height: 60,
                  //   decoration: BoxDecoration(
                  //     color: colors.secondaryBtnBg,
                  //     borderRadius: BorderRadius.circular(18),
                  //     border: Border.all(color: colors.inputBorder),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(Icons.fingerprint, color: colors.goldAccent),
                  //       const SizedBox(width: 10),
                  //       Text("الدخول ببصمة الإصبع",
                  //           style: TextStyle(color: colors.primary, fontWeight: FontWeight.w600)),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {},
                    child: RichText(
                      text: TextSpan(
                        text: "لا تملك حساباً؟ ",
                        style: TextStyle(color: colors.textSecondary),
                        children: [
                          TextSpan(
                            text: "تواصل مع الإدارة",
                            style: TextStyle(
                              color: colors.goldAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, AppColors colors) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          color: colors.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    AppColors colors,
    String hint,
    IconData icon, {
    Widget? suffixWidget,
    bool isPhone = false,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: isPhone
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 15),
                Icon(icon, color: colors.goldAccent),
                const SizedBox(width: 10),
                Text(
                  "+964 | ",
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Icon(icon, color: colors.goldAccent),
      suffixIcon: suffixWidget,
      filled: true,
      fillColor: colors.inputFill,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colors.primary, width: 1),
      ),
    );
  }
}
