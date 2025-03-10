import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// 渐变背景组件
class GradientBackground extends StatelessWidget {
  /// 子组件
  final Widget child;
  
  /// 渐变色
  final LinearGradient? gradient;
  
  /// 圆角半径
  final double borderRadius;
  
  /// 是否添加阴影
  final bool withShadow;
  
  /// 阴影颜色
  final Color? shadowColor;
  
  /// 阴影偏移
  final Offset shadowOffset;
  
  /// 阴影模糊半径
  final double shadowBlurRadius;
  
  /// 阴影扩散半径
  final double shadowSpreadRadius;

  /// 构造函数
  const GradientBackground({
    Key? key,
    required this.child,
    this.gradient,
    this.borderRadius = 16.0,
    this.withShadow = true,
    this.shadowColor,
    this.shadowOffset = const Offset(0, 4),
    this.shadowBlurRadius = 12.0,
    this.shadowSpreadRadius = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: shadowColor ?? Colors.black.withOpacity(0.1),
                  offset: shadowOffset,
                  blurRadius: shadowBlurRadius,
                  spreadRadius: shadowSpreadRadius,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
} 