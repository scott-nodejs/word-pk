import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'library_screen.dart';
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 切换标签页
  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 页面切换回调
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
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
          CommunityScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onIndexChanged: _onTabChanged,
      ),
    );
  }
} 