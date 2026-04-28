import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../BLoC/home_bloc.dart';
import '../BLoC/home_event.dart';
import '../BLoC/home_state.dart';

class ManagerMainHomePage extends StatelessWidget {
   ManagerMainHomePage({super.key});

  final List<Widget> _pages = [
   Container(color: Colors.purpleAccent.shade200,),
   Container(color: Colors.pinkAccent.shade200,),
   Container(color: Colors.purple.shade200,),
   Container(color: Colors.pink.shade200,),
   Container(color: Colors.deepPurple.shade200,),
  ];

  @override
  Widget build(BuildContext context) {

    final colors = AppColors();

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: colors.scaffoldBackground,
            
              body: _pages[state.currentIndex],
            
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: state.currentIndex,
                onTap: (index) {
                  context.read<HomeBloc>().add(ChangeTabEvent(index));
                },
                backgroundColor: colors.scaffoldBackground,
                selectedItemColor: colors.primary,
                unselectedItemColor: colors.textSecondary,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: "الرئيسية",
                  ),
                  BottomNavigationBarItem(icon: Icon(Icons.security), label: "الأمن"),
                  BottomNavigationBarItem(icon: Icon(Icons.), label: "الصيانة"),
                  BottomNavigationBarItem(icon: Icon(Icons.calendar_month_sharp), label: "المرافق"),
                  BottomNavigationBarItem(icon: Icon(Icons.people_outlined), label: "المجتمع"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
