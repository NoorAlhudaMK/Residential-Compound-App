import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Core/Colors/app_colors.dart';
import 'package:residential_compound_app/Core/UIConstants/aivio_border_radius.dart';
import 'package:residential_compound_app/Core/UIConstants/aivio_font_sizes.dart';

import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../MainPage/BLoC/home_bloc.dart';
import '../../MainPage/BLoC/home_event.dart';
import '../../Notification/BLoC/notification_bloc.dart';
import '../../Notification/BLoC/notification_state.dart';
import '../../Notification/View/notification_view.dart';
import '../../Profile/BLoC/profile_bloc.dart';
import '../../Profile/BLoC/profile_event.dart';
import '../../Profile/BLoC/profile_state.dart';
import '../BLoC/market_bloc.dart';
import '../BLoC/market_event.dart';
import '../BLoC/market_state.dart';
import 'cart_view.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        final colors = AppColors();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: colors.scaffoldBackground,
              appBar: AppBar(
                backgroundColor: colors.scaffoldBackground,
                elevation: 0.0,
                scrolledUnderElevation: 0.0,
                centerTitle: true,
                automaticallyImplyLeading: false,
                automaticallyImplyActions: false,
                leading: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.sm, right: AppSpacing.sm),
                  child: Image.asset(
                    profileState.isDark
                        ? "assets/images/aivio_logo_white.png"
                        : "assets/images/aivio_logo_black.png",
                    scale: 4,
                  ),
                ),
                leadingWidth: MediaQuery.of(context).size.width * .25,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.sm,
                      top: AppSpacing.sm,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.read<ProfileBloc>().add(
                          ToggleThemeEvent(!profileState.isDark),
                        );
                        context.read<HomeBloc>().add(ChangeTabEvent(2));
                      },
                      child: _buildCustomButton(
                        profileState.isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        false,
                        colors,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Padding(
                    padding: EdgeInsets.only(left: AppSpacing.sm, top: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationView(),
                        ),
                      ),
                      child: BlocBuilder<NotificationBloc, NotificationState>(
                        builder: (context, notificationState) {
                          bool hasUnread = false;

                          if (notificationState is NotificationLoaded) {
                            hasUnread = notificationState.notifications.any(
                                  (notification) => notification.readDate == null,
                            );
                          }

                          return _buildCustomButton(
                            Icons.notifications_none_rounded,
                            hasUnread,
                            colors,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              body: BlocBuilder<MarketBloc, MarketState>(
                builder: (context, state) {
                  if (state is MarketLoaded) {
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top Banner Image Card
                                Container(
                                  height: 220,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    image: const DecorationImage(
                                      image: AssetImage('assets/images/market_banner.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.75),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Cart Button with badge
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => BlocProvider.value(
                                                      value: BlocProvider.of<MarketBloc>(context),
                                                      child: const CartScreen(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'السلة',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 13,
                                                        color: Color(0xFF1C2A23),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    const Icon(Icons.arrow_forward_outlined, size: 16, color: Color(0xFF1C2A23)),
                                                    if (state.cartCount > 0) ...[
                                                      const SizedBox(width: 6),
                                                      CircleAvatar(
                                                        radius: 9,
                                                        backgroundColor: colors.primary,
                                                        child: Text(
                                                          '${state.cartCount}',
                                                          style: const TextStyle(fontSize: 10, color: Colors.white),
                                                        ),
                                                      ),
                                                    ]
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              'COMPOUND MARKET 🛍️',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'سوق AIVIO',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'احتياجات طازجة تصل إلى بابك.',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.9),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'تسوق بالقرب من منزلك',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textMain,
                                      ),
                                    ),
                                    Text(
                                      'عرض الكل',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: colors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                SizedBox(
                                  height: 44,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.categories.length,
                                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                                    itemBuilder: (context, index) {
                                      final cat = state.categories[index];
                                      final isSelected = state.selectedCategory == cat;

                                      return ChoiceChip(
                                        label: Text(cat),
                                        selected: isSelected,
                                        selectedColor: colors.primary,
                                        backgroundColor: colors.inputFill,
                                        labelStyle: TextStyle(
                                          color: isSelected ? Colors.white : colors.textMain,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          side: BorderSide(
                                            color: isSelected ? colors.primary : colors.inputBorder,
                                          ),
                                        ),
                                        onSelected: (selected) {
                                          context.read<MarketBloc>().add(ChangeCategory(cat));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                final product = state.products[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: colors.inputFill,
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.amber.shade100,
                                              borderRadius: BorderRadius.circular(16),
                                              image: DecorationImage(
                                                image: AssetImage(product.imageUrl),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.description,
                                                style: TextStyle(
                                                  fontSize: AppFontSizes.bodySmall,
                                                  color: colors.textSecondary,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                product.name,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: colors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            product.price,
                                            style: TextStyle(
                                              fontSize: AppFontSizes.bodySmall,
                                              fontWeight: FontWeight.bold,
                                              color: colors.textMain.withOpacity(0.8),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: colors.primary.withOpacity(0.12),
                                              foregroundColor: colors.primary,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            ),
                                            onPressed: () {
                                              context.read<MarketBloc>().add(AddToCart(product));

                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('تمت إضافة المنتج إلى السلة'),
                                                  duration: Duration(milliseconds: 800),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'إضافة',
                                              style: TextStyle(
                                                fontSize: AppFontSizes.bodySmall,
                                                fontWeight: FontWeight.bold,
                                                color: colors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: state.products.length,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomButton(IconData icon, bool hasNotification, AppColors colors) {
    return Container(
      width: AppIconSizes.xl,
      height: AppIconSizes.xl,
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: colors.textMain, size: AppIconSizes.md),
          if (hasNotification)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.danger,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}