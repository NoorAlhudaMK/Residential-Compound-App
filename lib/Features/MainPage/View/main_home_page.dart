import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Features/Billing/View/billing_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../Booking/View/booking_view.dart';
import '../../Community/View/community_view.dart';
import '../../Dashboard/View/dashboard_view.dart';
import '../../Maintenance/View/maintenance_view.dart';
import '../../Visitors/View/visitors_view.dart';
import '../BLoC/home_bloc.dart';
import '../BLoC/home_event.dart';
import '../BLoC/home_state.dart';

class MainHomePage extends StatelessWidget {
  MainHomePage({super.key});

  final List<Widget> _pages = [
    DashboardView(),
    VisitorView(),
    MaintenanceView(),
    BillingView(), //BookingView(),
    CommunityView(),
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
                  BottomNavigationBarItem(
                    icon: Icon(Icons.security),
                    label: "الأمن",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.build_outlined),
                    label: "الصيانة",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_sharp),
                    label: "المرافق",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_outlined),
                    label: "المجتمع",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
