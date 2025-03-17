import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 认证工具类
class AuthUtils {
  /// 私有构造函数
  AuthUtils._();
  
  /// 是否已登录
  static bool _isLoggedIn = false;
  
  /// 认证token
  static String? _token;
  
  /// 获取登录状态
  static bool get isLoggedIn => _isLoggedIn;
  
  /// 设置登录状态
  static set isLoggedIn(bool value) {
    _isLoggedIn = value;
    _saveLoginState();
  }
  
  /// 获取token
  static String? get token => _token;
  
  /// 设置token
  static set token(String? value) {
    _token = value;
    _saveLoginState();
  }
  
  /// 初始化认证状态
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _token = prefs.getString('token');
  }
  
  /// 保存登录状态
  static Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    if (_token != null) {
      await prefs.setString('token', _token!);
    } else {
      await prefs.remove('token');
    }
  }
  
  /// 清除登录信息
  static Future<void> clearLoginInfo() async {
    _isLoggedIn = false;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('token');
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