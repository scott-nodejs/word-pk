import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import 'avatar_widget.dart';

/// 顶部应用栏组件
/// 
/// 显示应用名称和右侧的通知按钮与用户头像
class TopAppBar extends StatelessWidget {
  /// 用户头像显示的文字
  final String initials;
  
  /// 点击通知按钮的回调
  final VoidCallback? onNotificationTap;
  
  /// 点击头像的回调
  final VoidCallback? onAvatarTap;

  /// 构造函数
  const TopAppBar({
    Key? key,
    required this.initials,
    this.onNotificationTap,
    this.onAvatarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 应用名称
          const Text(
            'WordDuel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          
          // 右侧按钮
          Row(
            children: [
              // 通知按钮
              GestureDetector(
                onTap: onNotificationTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // 用户头像
              GestureDetector(
                onTap: onAvatarTap,
                child: AvatarWidget(
                  initials: initials,
                  size: 32,
                  backgroundColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 