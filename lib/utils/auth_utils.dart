import 'package:flutter/material.dart';

/// 认证工具类
class AuthUtils {
  /// 私有构造函数
  AuthUtils._();
  
  /// 是否已登录
  static bool _isLoggedIn = false;
  
  /// 获取登录状态
  static bool get isLoggedIn => _isLoggedIn;
  
  /// 设置登录状态
  static set isLoggedIn(bool value) {
    _isLoggedIn = value;
  }
  
  /// 检查登录状态并根据需要导航到登录页面
  static Future<bool> checkLoginState(BuildContext context) async {
    if (!_isLoggedIn) {
      await Navigator.pushNamed(context, '/login');
      return false;
    }
    return true;
  }
} 