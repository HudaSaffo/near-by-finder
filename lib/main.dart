import 'package:flutter/material.dart';
import 'package:flutter_nearfix/CustomerServices.dart';
import 'package:flutter_nearfix/customerChat.dart';
import 'package:flutter_nearfix/login.dart';
import 'package:flutter_nearfix/serivceInformation.dart';
import 'package:flutter_nearfix/service.dart';
import 'package:flutter_nearfix/serviceChat.dart';
import 'package:flutter_nearfix/serviceDashboard.dart';
import 'package:flutter_nearfix/serviceRequests.dart';
import 'package:flutter_nearfix/serviceprofile.dart';
import 'package:flutter_nearfix/servicesInbox.dart';
import 'package:flutter_nearfix/signup.dart';
import 'package:flutter_nearfix/splashScreen.dart';
import './customerHome.dart';
import 'customerInbox.dart';
import 'customerMyRequests.dart';
import 'customerProfile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://kcnhrkawqvzidgvsvzpt.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtjbmhya2F3cXZ6aWRndnN2enB0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk5NzA3MTQsImV4cCI6MjA5NTU0NjcxNH0.g_UA-x-gc_0wd71xwcGAm2_Ioc9mr2y6j5K1IBRheg8",
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splashscreen',
      routes: {
        '/splashscreen': (context) => SplashScreen(),
        '/login': (context) => login_page(),
        '/signup': (context) => sign_up(),
        '/home': (context) => CustomerHome(),
        '/myrequests': (context) => MyRequests(),
        '/Customerservices': (context) => CustomerServices(),
        '/customerinbox': (context) => CustomerInbox(),
        '/customerprofile': (context) => CustomerProfile(),
        '/dashboard': (context) => ServiceDashboard(),
        '/serviceinformation': (context) => Serivceinformation(),
        '/servicerequest': (context) => ServiceRequests(),
        '/serviceprofile': (context) => ServiceProfile(),
        '/serviceinbox': (context) => ServiceInbox(),
      },
    );
  }
}
