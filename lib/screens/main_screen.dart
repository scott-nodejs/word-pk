import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'learning_screen.dart';
import 'community_screen.dart';
import 'profile_screen.dart';
import 'duel_matching_screen.dart';
import '../constants/app_theme.dart';

/// 主屏幕（包含底部导航栏和各个标签页）
class MainScreen extends StatefulWidget {
  /// 构造函数
  const MainScreen({Key? key}) : super(key: key);
  
  /// 全局键，用于访问MainScreen的State
  static final GlobalKey<_MainScreenState> mainScreenKey = GlobalKey<_MainScreenState>();
  
  /// 导航到指定的标签页
  static void navigateToTab(BuildContext context, int tabIndex) {
    final MainScreen? mainScreen = context.findAncestorWidgetOfExactType<MainScreen>();
    if (mainScreen != null && mainScreenKey.currentState != null) {
      mainScreenKey.currentState!._onTabChanged(tabIndex);
    }
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// 当前选中的标签页索引
  int _currentIndex = AppConstants.homeTabIndex;
  
  /// 社区通知数量
  int _communityNotificationCount = AppConstants.defaultCommunityNotificationCount;

  /// 切换标签页
  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
      
      // 如果点击的是社区标签，清除通知
      if (index == AppConstants.communityTabIndex && _communityNotificationCount > 0) {
        _communityNotificationCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          LibraryScreen(),
          DuelMatchingScreen(), // 对战页面
          CommunityScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        communityNotificationCount: _communityNotificationCount,
      ),
    );
  }
}

/// 脉冲动画效果已移至bottom_nav_bar.dart 