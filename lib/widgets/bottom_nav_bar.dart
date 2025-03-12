import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';

/// 底部导航栏组件
class BottomNavBar extends StatelessWidget {
  /// 当前选中的索引
  final int currentIndex;
  
  /// 索引变化回调
  final Function(int) onIndexChanged;
  
  /// 社区通知数量
  final int communityNotificationCount;
  
  /// 构造函数
  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onIndexChanged,
    this.communityNotificationCount = AppConstants.defaultCommunityNotificationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      height: 80, // 增加高度以适应浮动按钮
      child: Stack(
        children: [
          // 主导航栏
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: '首页',
                    index: AppConstants.homeTabIndex,
                  ),
                  _buildNavItem(
                    icon: Icons.book_outlined,
                    activeIcon: Icons.book,
                    label: '词库',
                    index: AppConstants.libraryTabIndex,
                  ),
                  // 中间的占位
                  const SizedBox(width: 50),
                  _buildNavItem(
                    icon: Icons.people_outline,
                    activeIcon: Icons.people,
                    label: '社区',
                    index: AppConstants.communityTabIndex,
                    showBadge: true,
                    badgeCount: communityNotificationCount,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: '我的',
                    index: AppConstants.profileTabIndex,
                  ),
                ],
              ),
            ),
          ),
          
          // 悬浮的"学习"按钮
          Positioned(
            left: 0,
            right: 0,
            top: 5, // 调整按钮位置
            child: Center(
              child: _buildFloatingActionButton(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建浮动学习按钮
  Widget _buildFloatingActionButton() {
    final isActive = currentIndex == AppConstants.learningTabIndex;
    
    return GestureDetector(
      onTap: () => onIndexChanged(AppConstants.learningTabIndex),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive 
                ? AppTheme.primaryColor.withOpacity(0.9)
                : AppTheme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 2), // 减少间距
          Text(
            '学习',
            style: TextStyle(
              color: isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
              fontSize: 10, // 调小字体
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建导航项
  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    bool showBadge = false,
    int badgeCount = 0,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor;
    
    return InkWell(
      onTap: () => onIndexChanged(index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0), // 调整为更小的内边距
        constraints: const BoxConstraints(minWidth: 50), // 设置最小宽度
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 调整主轴对齐方式
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: color,
                  size: 24,
                ),
                if (showBadge && badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.all(badgeCount > 9 ? 2 : 4), // 根据数字多少调整padding
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          badgeCount > 99 ? '99+' : badgeCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9, // 调小字体
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2), // 减少间距
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10, // 调小字体
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 