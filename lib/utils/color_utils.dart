import 'package:flutter/material.dart';

/// 颜色工具类
class ColorUtils {
  /// 将十六进制颜色字符串转换为Color对象
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// 将Color对象转换为十六进制颜色字符串
  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  /// 根据背景色自动计算适合的文本颜色（黑色或白色）
  static Color getTextColorForBackground(Color backgroundColor) {
    // 计算亮度
    final brightness = backgroundColor.computeLuminance();
    // 亮度大于0.5使用黑色文本，否则使用白色文本
    return brightness > 0.5 ? Colors.black : Colors.white;
  }

  /// 创建渐变色
  static LinearGradient createGradient(Color startColor, Color endColor) {
    return LinearGradient(
      colors: [startColor, endColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// 创建带透明度的颜色
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
} 