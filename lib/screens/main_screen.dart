import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'learning_screen.dart';
import 'community_screen.dart';
import 'profile_screen.dart';

/// 主屏幕（包含底部导航栏和各个标签页）
class MainScreen extends StatefulWidget {
  /// 构造函数
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// 当前选中的标签页索引
  int _currentIndex = AppConstants.homeTabIndex;
  
  /// 页面控制器
  final PageController _pageController = PageController(
    initialPage: AppConstants.homeTabIndex,
  );
  
  /// 社区通知数量
  int _communityNotificationCount = AppConstants.defaultCommunityNotificationCount;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 切换标签页
  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
      
      // 如果点击的是社区标签，清除通知
      if (index == AppConstants.communityTabIndex && _communityNotificationCount > 0) {
        _communityNotificationCount = 0;
      }
    });
    
    // 学习标签特殊处理：不使用PageView切换
    if (index == AppConstants.learningTabIndex) {
      // 直接打开学习页面而不是切换PageView
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LearningScreen(),
        ),
      ).then((_) {
        // 学习页面关闭后，恢复之前的标签
        setState(() {
          _currentIndex = _pageController.page!.round();
        });
      });
    } else {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 页面切换回调
  void _onPageChanged(int index) {
    if (index != AppConstants.learningTabIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // 禁用滑动切换
        children: const [
          HomeScreen(),
          LibraryScreen(),
          SizedBox(), // 空页面占位，实际不使用
          CommunityScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onIndexChanged: _onTabChanged,
        communityNotificationCount: _communityNotificationCount,
      ),
    );
  }
} 