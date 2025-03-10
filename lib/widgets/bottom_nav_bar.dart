import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';

/// 底部导航栏组件
class BottomNavBar extends StatelessWidget {
  /// 当前选中的索引
  final int currentIndex;
  
  /// 索引变化回调
  final Function(int) onIndexChanged;
  
  /// 构造函数
  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onIndexChanged,
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
              _buildNavItem(
                icon: Icons.people_outline,
                activeIcon: Icons.people,
                label: '社区',
                index: AppConstants.communityTabIndex,
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
    );
  }

  /// 构建导航项
  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor;
    
    return InkWell(
      onTap: () => onIndexChanged(index),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 