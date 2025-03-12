import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'constants/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用 Google Fonts 加载 Inter 字体
    final customTheme = AppTheme.lightTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(AppTheme.lightTheme.textTheme),
      primaryTextTheme: GoogleFonts.interTextTheme(AppTheme.lightTheme.primaryTextTheme),
      // 确保应用栏也使用Inter字体
      appBarTheme: AppTheme.lightTheme.appBarTheme.copyWith(
        titleTextStyle: GoogleFonts.inter(
          textStyle: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
      ),
    );
    
    return MaterialApp(
      title: 'WordDuel',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
    );
  }
} 