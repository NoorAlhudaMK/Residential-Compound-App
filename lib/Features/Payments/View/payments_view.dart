import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../../Data/Repositories/payment_reopsitory.dart';
import '../Bloc/payments_bloc.dart';
import '../Bloc/payments_event.dart';
import '../Bloc/payments_state.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentsBloc(
        repository: PaymentsRepository(),
      )..add( FetchPaymentsEvent(isRefresh: true, status: 'all')),
      child: const PaymentsBodyView(),
    );
  }
}

class PaymentsBodyView extends StatefulWidget {
  const PaymentsBodyView({Key? key}) : super(key: key);

  @override
  State<PaymentsBodyView> createState() => _PaymentsBodyViewState();
}

class _PaymentsBodyViewState extends State<PaymentsBodyView> {
  final ScrollController _scrollController = ScrollController();
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PaymentsBloc>().add(LoadMorePaymentsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: AppBar(
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
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: AppIconSizes.md,
              color: colors.textMain,
            ),
          ),
        ),
        body: Column(
          children: [
            // الفلتر الأفقي للحالات حسب الـ API
            Container(
              padding: AppSpacing.symmetricH,
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['all', 'completed', 'paid', 'pending', 'draft', 'cancelled'].map((status) {
                  final isSelected = _selectedStatus == status;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
                    child: ChoiceChip(
                      label: Text(status.toUpperCase()),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedStatus = status);
                          context.read<PaymentsBloc>().add(
                            FetchPaymentsEvent(isRefresh: true, status: status),
                          );
                        }
                      },
                      selectedColor: colors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : colors.textMain,
                        fontSize: AppFontSizes.caption,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: BlocBuilder<PaymentsBloc, PaymentsState>(
                builder: (context, state) {
                  if (state is PaymentsLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    );
                  } else if (state is PaymentsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(
                          fontSize: AppFontSizes.bodyMedium,
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is PaymentsLoaded) {
                    if (state.payments.isEmpty && state.paymentRequests.isEmpty) {
                      return Center(
                        child: Text(
                          'لا توجد بيانات متاحة حالياً',
                          style: TextStyle(
                            fontSize: AppFontSizes.bodyMedium,
                            color: colors.textSecondary,
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PaymentsBloc>().add(
                          FetchPaymentsEvent(isRefresh: true, status: _selectedStatus),
                        );
                      },
                      child: ListView(
                        controller: _scrollController,
                        padding: AppSpacing.allMd,
                        children: [
                          // بطاقة الملخص (Summary Card)
                          Container(
                            padding: AppSpacing.allMd,
                            decoration: BoxDecoration(
                              gradient: colors.primaryGradient,
                              borderRadius: AppRadius.mdRadius,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'إجمالي المدفوعات',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: AppFontSizes.bodySmall,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${state.summary.totalPayments}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: AppFontSizes.headingLarge,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'المبلغ الإجمالي المدفوع',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: AppFontSizes.bodySmall,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${state.summary.totalPaid} IQD',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: AppFontSizes.headingLarge,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // قائمة المدفوعات (Payments)
                          if (state.payments.isNotEmpty) ...[
                            Text(
                              'الــمــدفــوعــات',
                              style: TextStyle(
                                fontSize: AppFontSizes.headingSmall,
                                fontWeight: FontWeight.bold,
                                color: colors.textMain,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...state.payments.map((payment) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppRadius.mdRadius,
                                border: Border.all(color: const Color(0xFFF1F5F9)),
                              ),
                              padding: AppSpacing.allMd,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.payments_outlined,
                                      color: colors.primary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                payment.name,
                                                style: TextStyle(
                                                  fontSize: AppFontSizes.bodyLarge,
                                                  fontWeight: FontWeight.bold,
                                                  color: colors.textMain,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${payment.amount} ${payment.currency}',
                                              style: const TextStyle(
                                                fontSize: AppFontSizes.bodyMedium,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'التاريخ: ${payment.date}',
                                              style: TextStyle(
                                                fontSize: AppFontSizes.caption,
                                                color: colors.textSecondary,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: colors.statusApprovedBg,
                                                borderRadius: AppRadius.smRadius,
                                              ),
                                              child: Text(
                                                payment.state,
                                                style: TextStyle(
                                                  color: colors.statusApprovedText,
                                                  fontSize: AppFontSizes.caption,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],

                          // قائمة طلبات الدفع (Payment Requests)
                          if (state.paymentRequests.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'طلبات الدفع (Payment Requests)',
                              style: TextStyle(
                                fontSize: AppFontSizes.headingSmall,
                                fontWeight: FontWeight.bold,
                                color: colors.textMain,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...state.paymentRequests.map((req) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppRadius.mdRadius,
                                border: Border.all(color: const Color(0xFFF1F5F9)),
                              ),
                              padding: AppSpacing.allMd,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.account_balance_wallet_outlined,
                                      color: colors.primary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'طلب دفع رقم #${req.paymentRequestId}',
                                                style: TextStyle(
                                                  fontSize: AppFontSizes.bodyLarge,
                                                  fontWeight: FontWeight.bold,
                                                  color: colors.textMain,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${req.amount} ${req.currency}',
                                              style: TextStyle(
                                                fontSize: AppFontSizes.bodyMedium,
                                                fontWeight: FontWeight.bold,
                                                color: colors.textMain,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'رقم الفاتورة: ${req.invoiceId}',
                                              style: TextStyle(
                                                fontSize: AppFontSizes.caption,
                                                color: colors.textSecondary,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: colors.statusArrivedBg,
                                                borderRadius: AppRadius.smRadius,
                                              ),
                                              child: Text(
                                                req.state,
                                                style: TextStyle(
                                                  color: colors.statusArrivedText,
                                                  fontSize: AppFontSizes.caption,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],

                          if (state.isLoadingMore)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}