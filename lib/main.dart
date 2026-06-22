import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Features/Billing/BLoC/billing_bloc.dart';
import 'package:residential_compound_app/Features/Dashboard/BLoC/dashboard_bloc.dart';
import 'package:residential_compound_app/Features/Maintenance/BLoC/maintenance_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'Core/Colors/app_colors.dart';
import 'Features/Auth/BLoC/auth_bloc.dart';
import 'Features/Auth/View/login_view.dart';
import 'Features/Booking/BLoC/booking_bloc.dart';
import 'Features/Community/BLoC/community_bloc.dart';
import 'Features/MainPage/BLoC/home_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  checkUserToken();

  initializeDateFormatting('ar', null).then((_) {
    runApp(const MyApp());
  });
}

void checkUserToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();

    if (token != null) {
      print("✅ تم إنشاء معرف الجهاز بنجاح:");
      print("FCM Token: $token");
    } else {
      print("❌ فشل الحصول على المعرف.");
    }
  } else {
    print("⚠️ المستخدم رفض إعطاء صلاحية الإشعارات.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),

        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),

        BlocProvider<DashboardBloc>(create: (context) => DashboardBloc()),

        BlocProvider<MaintenanceBloc>(create: (context) => MaintenanceBloc()),

        BlocProvider<BookingBloc>(create: (context) => BookingBloc()),

        BlocProvider<CommunityBloc>(create: (context) => CommunityBloc()),

        BlocProvider<BillingBloc>(create: (context) => BillingBloc()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Residential Compound App',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: AppColors().textMain),
            bodyMedium: TextStyle(color: AppColors().textMain),
            titleLarge: TextStyle(color: AppColors().textMain, fontWeight: FontWeight.bold),
          ),
        ),
        home: const LoginView(),
      ),
    );
  }
}
