import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../Billing/View/billing_view.dart';
import '../../Dashboard/View/dashboard_view.dart';
import '../../Maintenance/ViewMaintenance/View/maintenance_view.dart';
import '../../Market/View/market_view.dart';
import '../../Market/Bloc/market_bloc.dart';
import '../../Market/Bloc/market_state.dart';
import '../../Profile/BLoC/profile_bloc.dart';
import '../../Profile/BLoC/profile_state.dart';
import '../../Settings/View/setting_view.dart';
import '../BLoC/home_bloc.dart';
import '../BLoC/home_event.dart';
import '../BLoC/home_state.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MarketBloc(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          final colors = AppColors();

          final TextStyle labelStyle = TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: colors.bottomBarIcon,
          );

          Icon _buildIcon(IconData iconData, Color color) {
            return Icon(iconData, color: color, size: 22);
          }

          final Color defaultIconColor = colors.bottomBarIcon.withOpacity(0.8);

          return BlocBuilder<HomeBloc, HomeState>(
            builder: (context, homeState) {
              final List<Widget> pages = [
                DashboardView(),
                MaintenanceView(),
                MarketScreen(),
                BillingView(),
                ProfileAndSettingsScreen(),
              ];

              return Directionality(
                textDirection: TextDirection.rtl,
                child: SafeArea(
                  child: Scaffold(
                    backgroundColor: colors.scaffoldBackground,
                    body: pages[homeState.currentIndex],
                    bottomNavigationBar: StylishBottomBar(
                      option: DotBarOptions(
                        dotStyle: DotStyle.tile,
                        gradient: LinearGradient(
                          colors: [colors.bottomBarIcon, colors.bottomBarIcon.withOpacity(0.6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      backgroundColor: colors.inputFill,
                      items: [
                        BottomBarItem(
                          icon: _buildIcon(Icons.home_outlined, defaultIconColor),
                          selectedIcon: _buildIcon(Icons.home, defaultIconColor),
                          title: Text('الرئيسية', style: labelStyle),
                          backgroundColor: colors.bottomBarIcon,
                        ),
                        BottomBarItem(
                          icon: _buildIcon(Icons.build_outlined, defaultIconColor),
                          selectedIcon: _buildIcon(Icons.build, defaultIconColor),
                          title: Text('الخدمات', style: labelStyle),
                          backgroundColor: colors.bottomBarIcon,
                        ),
                        BottomBarItem(
                          icon: BlocBuilder<MarketBloc, MarketState>(
                            builder: (context, marketState) {
                              int totalCartItems = 0;
                              if (marketState is MarketLoaded) {
                                totalCartItems = marketState.cartItems.length;
                              }
                              return Badge(
                                isLabelVisible: totalCartItems > 0,
                                label: Text('$totalCartItems'),
                                backgroundColor: colors.bottomBarIcon,
                                child: _buildIcon(Icons.card_travel_outlined, defaultIconColor),
                              );
                            },
                          ),
                          selectedIcon: BlocBuilder<MarketBloc, MarketState>(
                            builder: (context, marketState) {
                              int totalCartItems = 0;
                              if (marketState is MarketLoaded) {
                                totalCartItems = marketState.cartItems.length;
                              }
                              return Badge(
                                isLabelVisible: totalCartItems > 0,
                                label: Text('$totalCartItems'),
                                backgroundColor: colors.bottomBarIcon,
                                child: _buildIcon(Icons.card_travel_outlined, defaultIconColor),
                              );
                            },
                          ),
                          title: Text('المتجر', style: labelStyle),
                          backgroundColor: colors.bottomBarIcon,
                        ),
                        BottomBarItem(
                          icon: _buildIcon(Icons.receipt_long_outlined, defaultIconColor),
                          selectedIcon: _buildIcon(Icons.receipt_long, defaultIconColor),
                          title: Text('الفواتير', style: labelStyle),
                          backgroundColor: colors.bottomBarIcon,
                        ),
                        BottomBarItem(
                          icon: _buildIcon(Icons.menu, defaultIconColor),
                          selectedIcon: _buildIcon(Icons.menu, defaultIconColor),
                          title: Text('المزيد', style: labelStyle),
                          backgroundColor: colors.bottomBarIcon,
                        ),
                      ],
                      currentIndex: homeState.currentIndex,
                      onTap: (index) {
                        context.read<HomeBloc>().add(ChangeTabEvent(index));
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}