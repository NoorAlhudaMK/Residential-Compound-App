import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Core/Colors/app_colors.dart';

import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../BLoC/documents_bloc.dart';
import '../BLoC/documents_state.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppColors colors = AppColors();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: BlocProvider(
          create: (context) => DocumentsBloc(),
          child: Scaffold(
            backgroundColor: colors.scaffoldBackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'العقود والمستندات',
                style: TextStyle(
                  color: colors.textAppBar,
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
                  // Indicator line and Residence Branding
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Icon(
                        Icons.description_outlined,
                        size: 32,
                        color: colors.primary,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'AIVIO RESIDENCE',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.5,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'العقود والمستندات',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.textMain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Documents List from BLoC
                  Expanded(
                    child: BlocBuilder<DocumentsBloc, DocumentsState>(
                      builder: (context, state) {
                        if (state is DocumentsLoaded) {
                          return ListView.separated(
                            itemCount: state.documents.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final doc = state.documents[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: colors.inputFill,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.description_outlined,
                                      color: colors.primary,
                                    ),
                                  ),
                                  title: Text(
                                    doc.name,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: colors.primary,
                                    ),
                                  ),
                                  subtitle: Text(
                                    doc.details,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 16,
                                    color: colors.primary,
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