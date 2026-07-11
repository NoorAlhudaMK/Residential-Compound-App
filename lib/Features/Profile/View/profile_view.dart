import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Features/Auth/View/login_view.dart';

import '../../Auth/BLoC/auth_bloc.dart';
import '../../Auth/BLoC/auth_event.dart';
import '../../Auth/BLoC/auth_state.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
          );
        }
      },
      child:  Scaffold(
        appBar: AppBar(
          title: const Text("الملف الشخصي"),
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
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ),
              const SizedBox(height: 20),
              Text(
                username,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Text(buildingName, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Text(apartmentNumber, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),

              Expanded(
                child: ListView(
                  children: [
                    const Divider(),
                    _buildProfileItem(
                      context,
                      Icons.logout,
                      "تسجيل الخروج",
                      color: Colors.red,
                      onTap: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    IconData icon,
    String title, {
    Color color = Colors.black,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
