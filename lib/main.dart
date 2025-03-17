import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/study_plan_screen.dart';
import 'constants/app_theme.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/add_friend_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'utils/auth_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // 初始化认证状态
  await AuthUtils.init();
  
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
      title: 'Word Duel',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/study-plan': (context) => const StudyPlanScreen(),
        '/profile-edit': (context) => const ProfileEditScreen(),
        '/friends': (context) => const FriendsScreen(),
        '/add-friend': (context) => const AddFriendScreen(),
        '/home': (context) => const HomeScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
} 