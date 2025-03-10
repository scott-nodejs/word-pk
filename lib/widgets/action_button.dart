import 'package:flutter/material.dart';

/// 操作按钮样式类型
enum ActionButtonType {
  /// 主要按钮，使用填充色
  primary,
  
  /// 次要按钮，使用边框
  secondary,
}

/// 操作按钮组件
/// 
/// 提供统一样式的按钮，可以是主要按钮（filled）或次要按钮（outlined）
class ActionButton extends StatelessWidget {
  /// 按钮文本
  final String text;
  
  /// 按钮图标
  final IconData icon;
  
  /// 按钮类型
  final ActionButtonType type;
  
  /// 点击回调
  final VoidCallback onPressed;
  
  /// 自定义按钮颜色
  final Color? color;
  
  /// 按钮高度
  final double height;

  /// 构造函数
  const ActionButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.type = ActionButtonType.primary,
    this.color,
    this.height = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.primaryColor;
    
    // 根据按钮类型构建不同样式的按钮
    switch (type) {
      case ActionButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: Size(double.infinity, height),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(text),
            ],
          ),
        );
        
      case ActionButtonType.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: Size(double.infinity, height),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(text),
            ],
          ),
        );
    }
  }
} 