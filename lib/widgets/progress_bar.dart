import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// 自定义进度条组件
class ProgressBar extends StatelessWidget {
  /// 当前进度值（0.0 - 1.0）
  final double progress;
  
  /// 进度条高度
  final double height;
  
  /// 进度条背景颜色
  final Color backgroundColor;
  
  /// 进度条填充颜色
  final Color progressColor;
  
  /// 是否使用渐变色
  final bool useGradient;
  
  /// 渐变色
  final LinearGradient? gradient;
  
  /// 圆角半径
  final double borderRadius;
  
  /// 动画持续时间
  final Duration animationDuration;
  
  /// 构造函数
  const ProgressBar({
    Key? key,
    required this.progress,
    this.height = 8.0,
    this.backgroundColor = const Color(0xFFE5E7EB),
    this.progressColor = AppTheme.primaryColor,
    this.useGradient = false,
    this.gradient,
    this.borderRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: animationDuration,
            width: progress * MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: useGradient ? null : progressColor,
              gradient: useGradient
                  ? gradient ?? AppTheme.primaryGradient
                  : null,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ],
      ),
    );
  }
}

/// 双向进度条（用于对战页面）
class DualProgressBar extends StatelessWidget {
  /// 左侧进度值（0.0 - 1.0）
  final double leftProgress;
  
  /// 右侧进度值（0.0 - 1.0）
  final double rightProgress;
  
  /// 进度条高度
  final double height;
  
  /// 进度条背景颜色
  final Color backgroundColor;
  
  /// 左侧进度条颜色
  final Color leftColor;
  
  /// 右侧进度条颜色
  final Color rightColor;
  
  /// 圆角半径
  final double borderRadius;
  
  /// 动画持续时间
  final Duration animationDuration;
  
  /// 构造函数
  const DualProgressBar({
    Key? key,
    required this.leftProgress,
    required this.rightProgress,
    this.height = 8.0,
    this.backgroundColor = const Color(0x4DFFFFFF),
    this.leftColor = Colors.white,
    this.rightColor = Colors.white,
    this.borderRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          // 左侧进度
          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: animationDuration,
              width: leftProgress * screenWidth / 2,
              height: height,
              decoration: BoxDecoration(
                color: leftColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          
          // 右侧进度
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              duration: animationDuration,
              width: rightProgress * screenWidth / 2,
              height: height,
              decoration: BoxDecoration(
                color: rightColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 