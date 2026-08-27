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
import '../../MainPage/View/main_home_page.dart';
import '../BLoC/billing_bloc.dart';
import '../BLoC/billing_event.dart';
import '../BLoC/billing_state.dart';

class BillingView extends StatelessWidget {
  const BillingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocProvider(
      create: (context) =>
      BillingBloc(repository: BillingRepository())..add(LoadBills()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: _buildAppBar(colors, context),
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
      ),
    );
  }

  AppBar _buildAppBar(AppColors colors, BuildContext context) => AppBar(
    backgroundColor: colors.scaffoldBackground,
    elevation: 0,
    scrolledUnderElevation: 0.0,
    title: Text(
      "الفــواتــيــر والــمــدفــوعــات",
      style: TextStyle(
        color: colors.textMain,
        fontWeight: FontWeight.bold,
        fontSize: AppFontSizes.headingSmall,
      ),
    ),
    centerTitle: true,
    automaticallyImplyLeading: false,
    automaticallyImplyActions: false,
    leading: IconButton(
      icon: Icon(Icons.menu, size: AppIconSizes.md, color: colors.textMain),
      onPressed: () {
        showDrawer(
          context,
          builder: (context) {
            return AppDrawer();
          },
        );
      },
    ),
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
            const Text(
              "إجمالي الفواتير المستحقة",
              style: TextStyle(
                color: Colors.white70,
                fontSize: AppFontSizes.bodySmall,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentsView()));
              },
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
              label: const Text(
                "سجل الدفعات",
                style: TextStyle(color: Colors.white, fontSize: AppFontSizes.bodySmall),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          "${formatNumber(double.parse(state.totalUnpaidAmount.toString()))} د.ع",
          style: const TextStyle(
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
          color: isActive ? Colors.white : Colors.transparent,
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
        color: Colors.white,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: isSelected ? colors.primary : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          // Checkbox(
          //   value: isSelected,
          //   activeColor: colors.primary,
          //   onChanged: (_) => context.read<BillingBloc>().add(
          //     ToggleBillSelection(bill.id.toString()),
          //   ),
          // ),
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
          color: Colors.white,
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
}