import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart'; // تأكد من المسار الصحيح
import '../../Auth/BLoC/auth_bloc.dart';
import '../../Auth/BLoC/auth_event.dart';
import '../../Auth/BLoC/auth_state.dart';
import '../../Auth/View/login_view.dart';

class ProfileView extends StatelessWidget {
  final String username;
  final String buildingName;
  final String apartmentNumber;

  const ProfileView({
    super.key,
    required this.username,
    required this.buildingName,
    required this.apartmentNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: AppBar(
            title: Text(
                "الملف الشخصي",
              style: TextStyle(
                color: colors.textMain,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: colors.textMain,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            automaticallyImplyActions: false,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [colors.primary, Colors.blueAccent]),
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 15),
                Text(username, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textMain)),
                Text("$apartmentNumber - $buildingName", style: TextStyle(color: colors.textSecondary)),
                const SizedBox(height: 30),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    children: [
                      // _buildProfileItem(context, Icons.phone, "111", colors),
                      // const Divider(height: 1),
                      // _buildProfileItem(context, Icons.help_outline, "الدعم والمساعدة", colors),
                      // const Divider(height: 1),
                      _buildProfileItem(
                        context,
                        Icons.logout,
                        "تسجيل الخروج",
                        colors,
                        isLogout: true,
                        onTap: () => context.read<AuthBloc>().add(LogoutRequested()),
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
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String title, AppColors colors,
      {bool isLogout = false, VoidCallback? onTap}) {
    Color itemColor = isLogout ? Colors.red : colors.textMain;
    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(title, style: TextStyle(color: itemColor, fontWeight: FontWeight.w500)),
      trailing: isLogout ? const Icon(Icons.login_outlined, color: Colors.red, size: 20) : const Icon(Icons.arrow_back_ios, size: 16),
      onTap: onTap,
    );
  }
}
