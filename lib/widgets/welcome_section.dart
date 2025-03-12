import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// 欢迎信息组件
/// 
/// 显示用户名称和欢迎文本
class WelcomeSection extends StatelessWidget {
  /// 用户名
  final String name;
  
  /// 欢迎信息
  final String message;

  /// 构造函数
  const WelcomeSection({
    Key? key,
    required this.name,
    this.message = '继续你的学习之旅吧！',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '你好，$name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
} 