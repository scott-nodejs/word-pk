import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// 带有可选操作按钮的章节标题栏组件
class SectionHeader extends StatelessWidget {
  /// 标题文本
  final String title;
  
  /// 操作按钮文本
  final String? actionText;
  
  /// 操作按钮点击回调
  final VoidCallback? onActionTap;
  
  /// 标题文本样式
  final TextStyle? titleStyle;
  
  /// 操作按钮文本样式
  final TextStyle? actionStyle;

  /// 构造函数
  const SectionHeader({
    Key? key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.titleStyle,
    this.actionStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ?? const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
            fontSize: 16,
          ),
        ),
        if (actionText != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionText!,
              style: actionStyle ?? const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
} 