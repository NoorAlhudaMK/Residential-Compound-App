import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Data/Repositories/billing_repository.dart';
import 'package:residential_compound_app/Features/Payments/View/payments_view.dart';
import '../../../Core/FormattedDateTime/formatted_price.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../../Data/Models/invoice_model.dart';
import '../../Drawer/View/drawer_view.dart';
import '../../MainPage/BLoC/home_bloc.dart';
import '../../MainPage/BLoC/home_event.dart';
import '../../Notification/BLoC/notification_bloc.dart';
import '../../Notification/BLoC/notification_state.dart';
import '../../Notification/View/notification_view.dart';
import '../../Profile/BLoC/profile_bloc.dart';
import '../../Profile/BLoC/profile_event.dart';
import '../../Profile/BLoC/profile_state.dart';
import '../BLoC/billing_bloc.dart';
import '../BLoC/billing_event.dart';
import '../BLoC/billing_state.dart';

class BillingView extends StatelessWidget {
  const BillingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      BillingBloc(repository: BillingRepository())..add(LoadBills()),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          final colors = AppColors();

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: colors.scaffoldBackground,
              appBar: _buildAppBar(colors, context, profileState.isDark),
              body: BlocBuilder<BillingBloc, BillingState>(
                builder: (context, state) {
                  if (state.status == BillingStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Stack(
                    children: [
                      CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: AppSpacing.allLg,
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                _buildHeaderCard(context, state, colors),
                                const SizedBox(height: AppSpacing.lg),
                                _buildTabSwitcher(context, state, colors),
                                const SizedBox(height: AppSpacing.lg),
                                state.selectedTab == 0
                                    ? _buildUnpaidSection(context, state, colors)
                                    : _buildPaidSection(state, colors),
                                const SizedBox(height: 150),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColors colors, BuildContext context, bool isDark) => AppBar(
    backgroundColor: colors.scaffoldBackground,
    elevation: 0.0,
    scrolledUnderElevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    automaticallyImplyActions: false,
    leading: Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm, right: AppSpacing.sm),
      child: Image.asset(
        isDark
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
              ToggleThemeEvent(!isDark),
            );
            context.read<HomeBloc>().add(ChangeTabEvent(3));
          },
          child: _buildCustomButton(
            isDark
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
            builder: (context, state) {
              bool hasUnread = false;

              if (state is NotificationLoaded) {
                hasUnread = state.notifications.any(
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
  );

  Widget _buildHeaderCard(BuildContext context, BillingState state, AppColors colors) => Container(
    padding: AppSpacing.allLg,
    decoration: BoxDecoration(
      gradient: colors.primaryGradient,
      borderRadius: AppRadius.xlRadius,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "إجمالي الفواتير المستحقة",
              style: TextStyle(
                color: Colors.white,
                fontSize: AppFontSizes.bodySmall,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentsView()));
              },
              icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
              label: Text(
                "سجل الدفعات",
                style: TextStyle(color: Colors.white, fontSize: AppFontSizes.bodySmall),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          "${formatNumber(double.parse(state.totalUnpaidAmount.toString()))} د.ع",
          style: TextStyle(
            color: Colors.white,
            fontSize: AppFontSizes.displayLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  Widget _buildTabSwitcher(
      BuildContext context,
      BillingState state,
      AppColors colors,
      ) => Container(
    padding: const EdgeInsets.all(AppSpacing.xs),
    decoration: BoxDecoration(
      color: colors.secondaryBtnBg,
      borderRadius: AppRadius.mdRadius,
    ),
    child: Row(
      children: [
        _buildTab(context, "مستحقة", state.selectedTab == 0, 0, colors),
        _buildTab(context, "مدفوعة", state.selectedTab == 1, 1, colors),
      ],
    ),
  );

  Widget _buildTab(
      BuildContext context,
      String label,
      bool isActive,
      int index,
      AppColors colors,
      ) => Expanded(
    child: GestureDetector(
      onTap: () => context.read<BillingBloc>().add(ChangeTab(index)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isActive ? colors.tabFill : Colors.transparent,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.bodyMedium,
            color: isActive ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    ),
  );

  Widget _buildUnpaidBillCard(
      BuildContext context,
      InvoiceModel bill,
      BillingState state,
      AppColors colors,
      ) {
    bool isSelected = state.selectedBillIds.contains(bill.id.toString());
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: isSelected ? colors.primary : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSizes.bodyLarge,
                    color: colors.textMain,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  bill.dueDate,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: AppFontSizes.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${formatNumber(double.parse(bill.amountTotal.toString()))} د.ع",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.bodyLarge,
              color: colors.textMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaidSection(BillingState state, AppColors colors) => Column(
    children: state.paidBills
        .map(
          (p) => Container(
        padding: AppSpacing.allMd,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.inputFill,
          borderRadius: AppRadius.lgRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              p.name,
              style: TextStyle(
                fontSize: AppFontSizes.bodyLarge,
                color: colors.textMain,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${formatNumber(p.amountTotal)} د.ع",
              style: TextStyle(
                fontSize: AppFontSizes.bodyLarge,
                color: colors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    )
        .toList(),
  );

  Widget _buildUnpaidSection(
      BuildContext context,
      BillingState state,
      AppColors colors,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...state.bills.map(
              (bill) => _buildUnpaidBillCard(context, bill, state, colors),
        ),
      ],
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