import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/FormattedDateTime/formatted_price.dart';
import '../BLoC/billing_bloc.dart';
import '../BLoC/billing_event.dart';
import '../BLoC/billing_state.dart';

class BillingView extends StatelessWidget {
  const BillingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BillingBloc()..add(LoadBills()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          appBar: _buildAppBar(context),
          body: BlocBuilder<BillingBloc, BillingState>(
            builder: (context, state) {
              if (state.status == BillingStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            _buildHeaderCard(state),
                            const SizedBox(height: 25),
                            _buildTabSwitcher(context, state),
                            const SizedBox(height: 25),

                            // عرض المحتوى بناءً على التاب المختار
                            state.selectedTab == 0
                                ? _buildUnpaidSection(context, state)
                                : _buildPaidSection(state),

                            const SizedBox(height: 120), // مساحة للـ Bottom Bar
                          ]),
                        ),
                      ),
                    ],
                  ),

                  // إظهار شريط الدفع فقط في تاب "المستحقة"
                  if (state.selectedTab == 0) _buildBottomPaymentBar(context, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // --- تابات المحتوى ---

  Widget _buildUnpaidSection(BuildContext context, BillingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionHeader(context, state),
        const SizedBox(height: 15),
        ...state.bills.map((bill) => _buildUnpaidBillCard(context, bill, state)),
      ],
    );
  }

  Widget _buildPaidSection(BillingState state) {
    if (state.paidBills.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Icon(Icons.receipt_long_outlined, size: 60, color: Colors.grey.shade300),
              const SizedBox(height: 10),
              const Text("لا توجد فواتير مدفوعة سابقاً", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return Column(
      children: state.paidBills.map((bill) => _buildPaidBillCard(bill)).toList(),
    );
  }

  // --- تصميم البطاقات (Cards) ---

  Widget _buildUnpaidBillCard(BuildContext context, Map<String, dynamic> bill, BillingState state) {
    bool isSelected = state.selectedBillIds.contains(bill['id']);
    return GestureDetector(
      onTap: () => context.read<BillingBloc>().add(ToggleBillSelection(bill['id'])),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFB300) : const Color(0xFFF1F5F9),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            _buildCustomCheckbox(isSelected),
            const SizedBox(width: 15),
            _buildServiceIcon(bill),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bill['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(bill['date'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            _buildPriceAndStatus(bill),
          ],
        ),
      ),
    );
  }

  Widget _buildPaidBillCard(Map<String, dynamic> bill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(Icons.check, color: Color(0xFF4CAF50), size: 14),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bill['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(bill['paidDate'], style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("${formatNumber(double.parse(bill['amount'].toString()))} د.ع", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(bill['date'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  // --- مكونات الواجهة الصغيرة ---

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF102C57), size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text("الفواتير والمدفوعات",
          style: TextStyle(color: Color(0xFF102C57), fontWeight: FontWeight.bold, fontSize: 18)),
      centerTitle: true,
    );
  }

  Widget _buildHeaderCard(BillingState state) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF102C57),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("إجمالي الفواتير المستحقة", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text("${formatNumber(double.parse(state.totalDue.toString()))} د.ع",
                      style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
              _buildLateBadge(),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("فواتير غير مدفوعة 4", style: TextStyle(color: Colors.white, fontSize: 14)),
              TextButton(
                onPressed: () {},
                child: const Text("عرض السجل", style: TextStyle(color: Color(0xFFFFB300))),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTabSwitcher(BuildContext context, BillingState state) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          _buildTab(context, "مستحقة (4)", state.selectedTab == 0, 0),
          _buildTab(context, "مدفوعة", state.selectedTab == 1, 1),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, bool isActive, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<BillingBloc>().add(ChangeTab(index)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)] : null,
          ),
          child: Text(label, textAlign: TextAlign.center,
              style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? const Color(0xFF102C57) : Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildBottomPaymentBar(BuildContext context, BillingState state) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("المختار (${state.selectedBillIds.length})", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Text("${formatNumber(state.selectedTotal)}  د.ع",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF102C57))),
                  ],
                ),
                _buildApplePay()
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: state.selectedBillIds.isEmpty ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF102C57),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("ادفع الآن", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // --- أدوات مساعدة إضافية ---
  Widget _buildCustomCheckbox(bool isSelected) {
    return Container(
      width: 22, height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFFFFB300) : Colors.transparent,
        border: Border.all(color: isSelected ? const Color(0xFFFFB300) : Colors.grey.shade300),
      ),
      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
    );
  }

  Widget _buildServiceIcon(Map<String, dynamic> bill) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Color(bill['color']).withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(IconData(bill['icon'], fontFamily: 'MaterialIcons'), color: Color(bill['color']), size: 20),
    );
  }

  Widget _buildPriceAndStatus(Map<String, dynamic> bill) {
    bool isLate = bill['status'].contains('متأخرة');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("${formatNumber(double.parse(bill['amount'].toString()))} د.ع", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(bill['status'], style: TextStyle(color: isLate ? Colors.red : Colors.orange, fontSize: 10)),
      ],
    );
  }

  Widget _buildSelectionHeader(BuildContext context, BillingState state) {
    // التحقق هل جميع الفواتير مختارة حالياً؟
    bool isAllSelected = state.selectedBillIds.length == state.bills.length && state.bills.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("حدد الفواتير لدفعها معاً", style: TextStyle(color: Colors.grey, fontSize: 12)),
        TextButton(
          onPressed: () {
            context.read<BillingBloc>().add(SelectAllBills(!isAllSelected));
          },
          child: Text(
            isAllSelected ? "إلغاء الكل" : "تحديد الكل",
            style: const TextStyle(color: Color(0xFFFFB300), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildLateBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB300), size: 14),
          SizedBox(width: 5),
          Text("متأخرة 1", style: TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildApplePay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFFFF9E7), borderRadius: BorderRadius.circular(10)),
      child: const Row(
        children: [
          Icon(Icons.apple, size: 18),
          SizedBox(width: 5),
          Text("Apple Pay متاح", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}