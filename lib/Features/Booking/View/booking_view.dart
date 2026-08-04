import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart' hide OnDaySelected;

import '../../../Core/Colors/app_colors.dart';
import '../BLoC/booking_bloc.dart';
import '../BLoC/booking_event.dart';
import '../BLoC/booking_state.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return BlocProvider(
      create: (context) => BookingBloc(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("المرافق والحجوزات", style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
            centerTitle: true,
            automaticallyImplyActions: false,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFacilitiesList(),
                const SizedBox(height: 30),
                _buildFacilityDetails(colors),
                const SizedBox(height: 25),
                _buildCalendarSection(colors),
                const SizedBox(height: 25),
                _buildAvailableTimes(colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. بطاقات المرافق العلوية
  Widget _buildFacilitiesList() {
    return SizedBox(
      height: 220,
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.facilities.length,
            itemBuilder: (context, index) {
              final item = state.facilities[index];
              return GestureDetector(
                onTap: () => context.read<BookingBloc>().add(SelectFacility(index)),
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: item['colors'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [BoxShadow(color: item['colors'][1].withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                          child: Icon(item['icon'], color: Colors.white, size: 24),
                        ),
                      ),
                      const Spacer(),
                      Text(item['name'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Text(item['status'], style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 2. تفاصيل المرفق المختار
  Widget _buildFacilityDetails(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("قاعة المناسبات", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.people_outline, size: 18, color: colors.textSecondary),
            const SizedBox(width: 5),
            Text("شخص (الحد الأقصى) 50", style: TextStyle(color: colors.textSecondary, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  // 3. قسم التاريخ والتقويم
  Widget _buildCalendarSection(AppColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 18, color: colors.primary),
              const SizedBox(width: 10),
              const Text("تاريخ الحجز", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              return TableCalendar(
                locale: 'ar', // لدعم اللغة العربية
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: state.selectedDate,
                selectedDayPredicate: (day) => isSameDay(state.selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  context.read<BookingBloc>().add(OnDaySelected(selectedDay, focusedDay));
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: const TextStyle(fontSize: 14),
                  weekendTextStyle: const TextStyle(color: Colors.red),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  weekendStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 4. الأوقات المتاحة (تصميم مقترح)
  Widget _buildAvailableTimes(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("الأوقات المتاحة", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _timeChip("04:00 م", true, colors),
            _timeChip("06:00 م", false, colors),
            _timeChip("08:00 م", false, colors),
          ],
        ),
      ],
    );
  }

  Widget _timeChip(String time, bool isSelected, AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSelected ? colors.primary : const Color(0xFFF1F5F9)),
      ),
      child: Text(time, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
    );
  }
}