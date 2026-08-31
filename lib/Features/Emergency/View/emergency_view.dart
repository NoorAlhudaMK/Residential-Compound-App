import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Core/Colors/app_colors.dart';

import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../BLoC/emergency_bloc.dart';
import '../BLoC/emergency_event.dart';
import '../BLoC/emergency_state.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppColors colors = AppColors();
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: BlocProvider(
          create: (context) => EmergencyBloc(),
          child: Scaffold(
            backgroundColor: colors.scaffoldBackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'مركز الطوارئ',
                style: TextStyle(
                  color: colors.danger,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: AppSpacing.allSm,
                  decoration: BoxDecoration(
                    color: colors.inputFill,
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(color: colors.inputBorder),
                  ),
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: colors.textMain,
                    size: AppIconSizes.md,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              automaticallyImplyActions: false,
              automaticallyImplyLeading: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Header Card (طابع تحذيري خاص بالطوارئ)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.danger.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AIVIO CARE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 1.5,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'مركز الطوارئ',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: colors.danger,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 32,
                              color: colors.danger,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'عند وجود خطر فورى، اتصل برقم الطوارئ المحلي أولاً.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section Title
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اختر نوع الطوارئ:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Emergency Options List from BLoC
                  Expanded(
                    child: BlocBuilder<EmergencyBloc, EmergencyState>(
                      builder: (context, state) {
                        if (state is EmergencyLoaded) {
                          return ListView.separated(
                            itemCount: state.options.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final option = state.options[index];
                              final isSelected = state.selectedIndex == index;

                              return GestureDetector(
                                onTap: () {
                                  context.read<EmergencyBloc>().add(SelectEmergencyType(index));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colors.inputFill,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? colors.danger : Colors.transparent,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: colors.danger.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        option.icon,
                                        color: colors.danger,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      option.title,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textMain,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),

                  // Trigger Emergency Team Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.danger,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        context.read<EmergencyBloc>().add(TriggerEmergencyAlert());
                      },
                      child: const Text(
                        'تنبيه فريق المجمع',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}