import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:residential_compound_app/Features/Billing/View/billing_view.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../Dashboard/View/dashboard_view.dart';
import '../../Maintenance/ViewMaintenance/View/maintenance_view.dart';
import '../../Visitors/ViewVisitors/View/visitors_view.dart';
import '../BLoC/home_bloc.dart';
import '../BLoC/home_event.dart';
import '../BLoC/home_state.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({super.key});

  // 1. اجعلي الـ Controller هنا كمتغير static عام ليتم الوصول إليه بسهولة
  static final DrawerScaffoldController drawerController = DrawerScaffoldController();

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {

  final List<Widget> _pages = [
    DashboardView(),
    VisitorView(),
    MaintenanceView(),
    BillingView(),
  ];

  final Menu menu = Menu(
    items: [
      MenuItem(id: 0, title: 'الرئيسية', icon: Icons.home),
      MenuItem(id: 1, title: 'الزوار', icon: Icons.security),
      MenuItem(id: 2, title: 'الصيانة', icon: Icons.build),
      MenuItem(id: 3, title: 'الفواتير', icon: Icons.receipt_long),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DrawerScaffold(
            controller: MainHomePage.drawerController,
            drawers: [
              SideDrawer(
                percentage: 0.9,
                menu: menu,
                direction: Direction.right,
                animation: true,
                color: colors.primary,
                selectedItemId: state.currentIndex,
                onMenuItemSelected: (itemId) {
                  context.read<HomeBloc>().add(ChangeTabEvent(itemId));
                },
              ),
            ],
            builder: (context, id) {
              return SafeArea(
                child: Scaffold(
                  backgroundColor: colors.scaffoldBackground,
                  body: _pages[state.currentIndex],
                  bottomNavigationBar: StylishBottomBar(
                    option: DotBarOptions(
                      dotStyle: DotStyle.tile,
                      gradient: LinearGradient(
                        colors: [colors.primary, colors.primary.withOpacity(0.6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    items: [
                      BottomBarItem(
                        icon: Icon(Icons.home_outlined, color: colors.primary.withOpacity(0.8), size: 22),
                        selectedIcon: Icon(Icons.home, color: colors.primary.withOpacity(0.8), size: 22),
                        title: const Text('الرئيسية', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        backgroundColor: colors.primary,
                      ),
                      BottomBarItem(
                        icon: Icon(Icons.security_outlined, color: colors.primary.withOpacity(0.8), size: 22),
                        selectedIcon: Icon(Icons.security, color: colors.primary.withOpacity(0.8), size: 22),
                        title: const Text('الزوار', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        backgroundColor: colors.primary,
                      ),
                      BottomBarItem(
                        icon: Icon(Icons.build_outlined, color: colors.primary.withOpacity(0.8), size: 22),
                        selectedIcon: Icon(Icons.build, color: colors.primary.withOpacity(0.8), size: 22),
                        title: const Text('الصيانة', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        backgroundColor: colors.primary,
                      ),
                      BottomBarItem(
                        icon: Icon(Icons.receipt_long_outlined, color: colors.primary.withOpacity(0.8), size: 22),
                        selectedIcon: Icon(Icons.receipt_long, color: colors.primary.withOpacity(0.8), size: 22),
                        title: const Text('الفواتير', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        backgroundColor: colors.primary,
                      ),
                    ],
                    currentIndex: state.currentIndex,
                    onTap: (index) {
                      context.read<HomeBloc>().add(ChangeTabEvent(index));
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}