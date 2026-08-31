import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Core/UIConstants/aivio_border_radius.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../../Core/UIConstants/aivio_spacing.dart';
import '../../../Drawer/View/drawer_view.dart';
import '../../../MainPage/View/main_home_page.dart';
import '../../AddNewVisitor/View/add_new_visitor.dart';
import '../BLoC/visitors_bloc.dart';
import '../BLoC/visitors_event.dart';
import '../BLoC/visitors_state.dart';

class VisitorView extends StatefulWidget {
  const VisitorView({super.key});

  @override
  State<VisitorView> createState() => _VisitorViewState();
}

class _VisitorViewState extends State<VisitorView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _statuses = [
    {'key': '', 'label': 'All'},
    {'key': 'pending', 'label': 'Pending'},
    {'key': 'approved', 'label': 'Approved'},
    {'key': 'arrived', 'label': 'Arrived'},
    {'key': 'checked_out', 'label': 'Checked Out'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<VisitorBloc>().add(FetchVisitors(status: ''));

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      final bloc = context.read<VisitorBloc>();
      if (bloc.state.hasMore &&
          !bloc.state.isMoreLoading &&
          !bloc.state.isLoading) {
        bloc.add(FetchVisitors(isPagination: true));
      }
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
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'arrived':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'checked_out':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'الزوار',
              style: TextStyle(
                color: colors.textMain,
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
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.xl),
                Container(
                  width: AppFontSizes.headingLarge,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(
                      AppFontSizes.bodySmall,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AIVIO ACCESS',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      "الزوار",
                      style: TextStyle(
                        color: colors.textMain,
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.headingMedium,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddNewVisitorView(),
                          ),
                        );
                      },
                      child: Container(
                        padding: AppSpacing.allSm,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: AppRadius.mdRadius,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: AppIconSizes.md,
                              color: Colors.white,
                            ),
                            Text(
                              "إضافة زائر",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSizes.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: AppSpacing.sm,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      context.read<VisitorBloc>().add(SearchVisitors(query));
                    },
                    decoration: InputDecoration(
                      hintText: "ابحث بالاسم، رقم الهاتف، أو رقم اللوحة...",
                      hintStyle: TextStyle(
                        color: colors.textSecondary,
                        fontSize: AppFontSizes.bodySmall,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: colors.textSecondary,
                        size: AppIconSizes.md,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: colors.textSecondary,
                                size: AppIconSizes.sm,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                context.read<VisitorBloc>().add(SearchVisitors(''));
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: colors.inputFill,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colors.inputBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colors.primary),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 50,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                //     itemCount: _statuses.length,
                //     itemBuilder: (context, index) {
                //       final status = _statuses[index];
                //       return BlocBuilder<VisitorBloc, VisitorState>(
                //         builder: (context, state) {
                //           final isSelected = state.currentStatus == status['key'];
                //           return Padding(
                //             padding: const EdgeInsets.only(left: 8.0),
                //             child: ChoiceChip(
                //               label: Text(status['label']!),
                //               selected: isSelected,
                //               selectedColor: colors.primary,
                //               backgroundColor: Colors.white,
                //               labelStyle: TextStyle(
                //                 color: isSelected ? Colors.white : colors.textSecondary,
                //                 fontWeight: FontWeight.w600,
                //               ),
                //               onSelected: (selected) {
                //                 if (selected) {
                //                   context.read<VisitorBloc>().add(
                //                     FetchVisitors(status: status['key'], page: 1),
                //                   );
                //                 }
                //               },
                //             ),
                //           );
                //         },
                //       );
                //     },
                //   ),
                // ),
        
                //SizedBox(height: AppSpacing.xs),
                Expanded(
                  child: BlocConsumer<VisitorBloc, VisitorState>(
                    listener: (context, state) {
                      if (state.errorMessage != null &&
                          !state.isLoading &&
                          !state.isMoreLoading) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.isLoading && state.filteredVisitors.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
        
                      if (state.filteredVisitors.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_off_outlined,
                                size: 64,
                                color: colors.textSecondary,
                              ),
                              SizedBox(height: AppSpacing.sm),
                              Text(
                                "لا يوجد زوار مطابقين",
                                style: TextStyle(
                                  color: colors.textSecondary,
                                  fontSize: AppFontSizes.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
        
                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.sm,),
                        itemCount:
                            state.filteredVisitors.length +
                            (state.isMoreLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.filteredVisitors.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
        
                          final visitor = state.filteredVisitors[index];
                          final statusColor = _getStatusColor(visitor.status);
        
                          return Container(
                            margin: EdgeInsets.only(bottom: AppSpacing.md),
                            padding: EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: colors.inputFill,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: statusColor.withOpacity(0.15),
                                  child: Icon(
                                    Icons.person,
                                    color: statusColor,
                                    size: AppIconSizes.md,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.md),
        
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        visitor.visitorName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: AppFontSizes.bodyLarge,
                                          color: colors.textMain,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        visitor.visitorPhone?.isNotEmpty == true
                                            ? visitor.visitorPhone!
                                            : 'رقم الهاتف غير متوفر',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.bodySmall,
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      visitor.visitDatetime?.isNotEmpty == true
                                          ? Text(
                                       "الدخول: " + formatDateTime(visitor.visitDatetime!).replaceFirst("PM", "مساءً").replaceFirst("AM", "صباحاً"),
                                        style: TextStyle(
                                          fontSize: AppFontSizes.bodySmall,
                                          color: colors.textSecondary,
                                        ),
                                      ) : Container(),
                                      SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          visitor.status.toUpperCase(),
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: AppFontSizes.bodySmall,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
        
                                if (visitor.status.toLowerCase() == 'approved') ...[
                                  SizedBox(width: AppSpacing.sm),
                                  IconButton(
                                    onPressed: () {
                                      final String shareText =
                                          "تصريح دخول الزائر: ${visitor.visitorName}\n"
                                          "رمز التحقق (QR Token): ${visitor.qrToken}\n"
                                          "مرحباً بك في المجمع السكني.";
        
                                      Share.share(shareText);
                                    },
                                    icon: Icon(
                                      Icons.share_rounded,
                                      color: colors.statusApprovedText,
                                      size: AppIconSizes.md,
                                    ),
                                    tooltip: 'مشاركة التصريح',
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDateTime(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = intl.DateFormat('yyyy/MM/dd  hh:mm a').format(dateTime);
    return formattedDate;
  }
}
