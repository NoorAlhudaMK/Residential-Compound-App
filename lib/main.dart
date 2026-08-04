import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:residential_compound_app/Data/Repositories/community_repository.dart';
import 'package:residential_compound_app/Data/Repositories/notification_repository.dart';
import 'package:residential_compound_app/Data/Repositories/payment_reopsitory.dart';
import 'package:residential_compound_app/Features/Billing/BLoC/billing_bloc.dart';
import 'package:residential_compound_app/Features/Dashboard/BLoC/dashboard_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:residential_compound_app/Features/Notification/BLoC/notification_bloc.dart';
import 'package:residential_compound_app/Features/Payments/BLoC/payments_bloc.dart';

import 'Core/CacheManager/cache_manager.dart';
import 'Core/Colors/app_colors.dart';
import 'Data/Repositories/auth_repository.dart';
import 'Data/Repositories/billing_repository.dart';
import 'Data/Repositories/home_repository.dart';
import 'Data/Repositories/maintenance_repository.dart';
import 'Data/Repositories/visitor_repository.dart';
import 'Features/Auth/BLoC/auth_bloc.dart';
import 'Features/Auth/View/login_view.dart';
import 'Features/Booking/BLoC/booking_bloc.dart';
import 'Features/Community/BLoC/community_bloc.dart';
import 'Features/Dashboard/BLoC/dashboard_event.dart';
import 'Features/MainPage/BLoC/home_bloc.dart';
import 'Features/MainPage/View/main_home_page.dart';
import 'Features/Maintenance/ViewMaintenance/BLoC/maintenance_bloc.dart';
import 'Features/Maintenance/ViewMaintenance/BLoC/maintenance_event.dart';
import 'Features/Notification/BLoC/notification_event.dart';
import 'Features/Visitors/ViewVisitors/BLoC/visitors_bloc.dart';
import 'Features/Visitors/ViewVisitors/BLoC/visitors_event.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await requestNotificationPermission();

  String? fcmToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print("🔔 FCM Token: $fcmToken");
  }

  await FirebaseInAppMessaging.instance.setMessagesSuppressed(false);

  String? token = await CacheManager.getToken();
  bool isValidSession = false;

  if (token != null) {
    try {
      await AuthRepository().fetchAndCacheUserProfile(token);

      bool hasAccess = await AuthRepository().checkUserAccess(token);

      isValidSession = hasAccess;
    } catch (e) {
      if (kDebugMode) {
        print("خطأ في التحقق من الجلسة عند التشغيل: $e");
      }
      await CacheManager.clearAll();
      isValidSession = false;
    }
  }

  initializeDateFormatting('ar', null).then((_) {
    runApp(MyApp(isLoggedIn: token != null));
  });

  FlutterNativeSplash.remove();
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    if (kDebugMode) print("✅ تم منح صلاحية الإشعارات.");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    if (kDebugMode) print("✅ تم منح صلاحية مؤقتة.");
  } else {
    if (kDebugMode) print("⚠️ تم رفض صلاحية الإشعارات.");
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),

        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),

        BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(
            repository: RepositoryProvider.of<HomeRepository>(context),
          )..add(FetchDashboardData()),
        ),

        BlocProvider<MaintenanceBloc>(
          create: (context) =>
              MaintenanceBloc(repository: MaintenanceRepository())
                ..add(LoadMaintenanceData()),
        ),

        BlocProvider<BookingBloc>(create: (context) => BookingBloc()),

        BlocProvider<CommunityBloc>(
          create: (context) => CommunityBloc(repository: CommunityRepository()),
        ),

        BlocProvider<BillingBloc>(
          create: (context) => BillingBloc(repository: BillingRepository()),
        ),

 BlocProvider<PaymentsBloc>(
          create: (context) => PaymentsBloc(repository: PaymentsRepository()),
        ),

        BlocProvider<VisitorBloc>(
          create: (context) =>
              VisitorBloc(repository: VisitorRepository())
                ..add(FetchVisitors()),
        ),

        BlocProvider<NotificationBloc>(
          create: (context) =>
              NotificationBloc(NotificationRepository())
                ..add(LoadNotifications()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Residential Compound App',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: AppColors().textMain),
            bodyMedium: TextStyle(color: AppColors().textMain),
            titleLarge: TextStyle(
              color: AppColors().textMain,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: isLoggedIn ? MainHomePage() : const LoginView(),
      ),
    );
  }
}
