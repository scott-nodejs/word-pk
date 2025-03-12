import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../utils/color_utils.dart';

/// 用户头像组件
class AvatarWidget extends StatelessWidget {
  /// 用户头像URL
  final String? avatarUrl;
  
  /// 用户名首字母
  final String initials;
  
  /// 头像大小
  final double size;
  
  /// 背景颜色
  final Color? backgroundColor;
  
  /// 文本颜色
  final Color? textColor;
  
  /// 边框宽度
  final double borderWidth;
  
  /// 边框颜色
  final Color? borderColor;
  
  /// 是否显示在线状态
  final bool showOnlineStatus;
  
  /// 是否在线
  final bool isOnline;
  
  /// 构造函数
  const AvatarWidget({
    Key? key,
    this.avatarUrl,
    required this.initials,
    this.size = 40.0,
    this.backgroundColor,
    this.textColor,
    this.borderWidth = 0.0,
    this.borderColor,
    this.showOnlineStatus = false,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppTheme.primaryColor;
    final txtColor = textColor ?? Colors.white;
    final fontSize = size * 0.4;
    final fontWeight = FontWeight.bold;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? Colors.white,
                width: borderWidth,
              )
            : null,
      ),
      child: Stack(
        children: [
          // 头像或首字母
          Center(
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(size / 2),
                    child: Image.network(
                      avatarUrl!,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildInitials(fontSize, fontWeight, txtColor);
                      },
                    ),
                  )
                : _buildInitials(fontSize, fontWeight, txtColor),
          ),
          
          // 在线状态指示器
          if (showOnlineStatus)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline ? Colors.green : Colors.grey,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建首字母显示
  Widget _buildInitials(double fontSize, FontWeight fontWeight, Color txtColor) {
    return Text(
      initials,
      style: TextStyle(
        color: txtColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
} 