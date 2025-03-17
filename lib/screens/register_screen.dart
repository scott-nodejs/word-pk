import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../constants/app_theme.dart';
import '../utils/auth_utils.dart';
import '../services/word_service.dart';

/// 注册页面
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// 是否同意用户协议
  bool _agreedToTerms = false;
  
  /// 是否显示密码
  bool _showPassword = false;
  
  /// 是否显示确认密码
  bool _showConfirmPassword = false;
  
  /// 手机号Controller
  final TextEditingController _phoneController = TextEditingController();
  
  /// 密码Controller
  final TextEditingController _passwordController = TextEditingController();
  
  /// 确认密码Controller
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  /// 验证码Controller
  final TextEditingController _verifyCodeController = TextEditingController();
  
  /// 是否正在加载
  bool _isLoading = false;
  
  /// 验证码倒计时
  int _countDown = 0;
  
  /// 单词服务
  final _wordService = WordService();
  
  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verifyCodeController.dispose();
    super.dispose();
  }
  
  /// 处理注册
  Future<void> _handleRegister() async {
    // 表单验证
    if (_phoneController.text.isEmpty) {
      _showMessage('请输入手机号');
      return;
    }
    
    if (_verifyCodeController.text.isEmpty) {
      _showMessage('请输入验证码');
      return;
    }
    
    if (_passwordController.text.isEmpty) {
      _showMessage('请输入密码');
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessage('两次输入密码不一致');
      return;
    }
    
    if (!_agreedToTerms) {
      _showMessage('请阅读并同意用户协议');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await _wordService.register(
        _phoneController.text,
        _passwordController.text,
        _verifyCodeController.text,
      );
      
      if (success) {
        // 注册成功，自动登录
        await _wordService.login(
          _phoneController.text,
          _passwordController.text,
        );
        
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _showMessage('注册失败，请稍后重试');
      }
    } catch (e) {
      _showMessage('注册失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  /// 发送验证码
  Future<void> _sendVerifyCode() async {
    if (_phoneController.text.isEmpty) {
      _showMessage('请输入手机号');
      return;
    }
    
    if (_countDown > 0) {
      return;
    }
    
    setState(() {
      _countDown = 60;
    });
    
    // 启动倒计时
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_countDown > 0) {
            _countDown--;
          }
        });
      }
      return _countDown > 0;
    });
    
    try {
      final success = await _wordService.sendVerifyCode(
        _phoneController.text,
        type: 'register',
      );
      
      if (!success) {
        _showMessage('验证码发送失败，请稍后重试');
      }
    } catch (e) {
      _showMessage('发送验证码失败: $e');
    }
  }
  
  /// 显示消息
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 顶部导航
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.grey[500],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        '登录',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 注册头部
              Container(
                padding: const EdgeInsets.fromLTRB(40, 24, 40, 32),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu_book_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '创建 WordDuel 账号',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '开始您的单词学习之旅',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              // 注册表单
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 手机号输入
                    const Text(
                      '手机号',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '+86',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(12),
                              ),
                            ),
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: '请输入手机号',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 验证码输入
                    const Text(
                      '验证码',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(12),
                              ),
                            ),
                            child: TextField(
                              controller: _verifyCodeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: '请输入验证码',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(12),
                            ),
                          ),
                          child: TextButton(
                            onPressed: _sendVerifyCode,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            child: Text(
                              _countDown > 0 ? '$_countDown秒后重试' : '获取验证码',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 密码输入
                    const Text(
                      '设置密码',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            decoration: const InputDecoration(
                              hintText: '请设置6-20位密码',
                              hintStyle: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey[500],
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 确认密码
                    const Text(
                      '确认密码',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: !_showConfirmPassword,
                            decoration: const InputDecoration(
                              hintText: '请再次输入密码',
                              hintStyle: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _showConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey[500],
                            ),
                            onPressed: () {
                              setState(() {
                                _showConfirmPassword = !_showConfirmPassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 用户协议
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _agreedToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreedToTerms = value ?? false;
                              });
                            },
                            activeColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: '我已阅读并同意 ',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                              children: [
                                TextSpan(
                                  text: '《用户协议》',
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // 打开用户协议
                                    },
                                ),
                                const TextSpan(text: '和'),
                                TextSpan(
                                  text: '《隐私政策》',
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // 打开隐私政策
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 注册按钮
                    ElevatedButton(
                      onPressed: _agreedToTerms && !_isLoading ? _handleRegister : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              '立即注册',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 