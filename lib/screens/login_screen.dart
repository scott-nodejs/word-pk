import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../constants/app_theme.dart';
import '../utils/auth_utils.dart';
import '../services/word_service.dart';

/// 登录页面
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// 当前选中的登录方式：true为验证码登录，false为密码登录
  bool _isVerifyCodeLogin = true;
  
  /// 手机号Controller
  final TextEditingController _phoneController = TextEditingController();
  
  /// 密码Controller
  final TextEditingController _passwordController = TextEditingController();
  
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
    _verifyCodeController.dispose();
    super.dispose();
  }

  /// 处理登录
  Future<void> _handleLogin() async {
    // 防止重复点击
    if (_isLoading) {
      return;
    }
    
    // 表单验证
    if (_phoneController.text.isEmpty) {
      _showMessage('请输入手机号');
      return;
    }
    
    if (_isVerifyCodeLogin) {
      if (_verifyCodeController.text.isEmpty) {
        _showMessage('请输入验证码');
        return;
      }
    } else {
      if (_passwordController.text.isEmpty) {
        _showMessage('请输入密码');
        return;
      }
    }
    
    setState(() {
      _isLoading = true;
    });
    
    bool success = false;
    
    try {
      if (_isVerifyCodeLogin) {
        // 验证码登录
        success = await _wordService.loginWithVerifyCode(
          _phoneController.text,
          _verifyCodeController.text,
        );
      } else {
        // 密码登录
        success = await _wordService.login(
          _phoneController.text,
          _passwordController.text,
        );
      }
      
      // 确保组件仍然挂载
      if (!mounted) return;
      
      if (success) {
        // 登录成功后使用Future.microtask延迟执行导航操作
        // 这样可以确保当前事件循环完成后再执行导航
        Future.microtask(() {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      } else {
        // 登录失败只显示错误消息，不跳转
        _showMessage(_isVerifyCodeLogin ? '验证码错误或已过期' : '手机号或密码错误');
      }
    } catch (e) {
      // 发生异常也只显示错误消息，不跳转
      if (mounted) {
        _showMessage('登录失败: $e');
      }
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
      final success = await _wordService.sendVerifyCode(_phoneController.text);
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
        child: Stack(
          children: [
            // 主要内容
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顶部导航
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            color: const Color(0xFF6B7280),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/register');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              '注册',
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
                    const SizedBox(height: 12),
                    
                    // Logo图标
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5), // indigo-600
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.menu_book,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // 登录表单
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 选项卡
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildTabButton(
                                    '验证码登录',
                                    _isVerifyCodeLogin,
                                    () => setState(() => _isVerifyCodeLogin = true),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTabButton(
                                    '密码登录',
                                    !_isVerifyCodeLogin,
                                    () => setState(() => _isVerifyCodeLogin = false),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // 手机号输入
                          const Text(
                            '手机号',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 8),
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
                          
                          // 验证码/密码输入
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isVerifyCodeLogin ? '验证码' : '密码',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              if (!_isVerifyCodeLogin)
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/forgot-password');
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    '忘记密码？',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.horizontal(
                                      left: const Radius.circular(12),
                                      right: _isVerifyCodeLogin
                                          ? Radius.zero
                                          : const Radius.circular(12),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _isVerifyCodeLogin ? _verifyCodeController : _passwordController,
                                    obscureText: !_isVerifyCodeLogin,
                                    keyboardType: _isVerifyCodeLogin
                                        ? TextInputType.number
                                        : TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText:
                                          _isVerifyCodeLogin ? '请输入验证码' : '请输入密码',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (_isVerifyCodeLogin)
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
                          const SizedBox(height: 24),
                          
                          // 登录按钮
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 1,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      '登录',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 其他登录方式
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(color: Color(0xFFE5E7EB)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '其他登录方式',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Color(0xFFE5E7EB)),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 第三方登录按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialLoginButton(
                          color: const Color(0xFF10B981),
                          icon: Icons.wechat,
                          onTap: () {
                            // 微信登录
                          },
                        ),
                        const SizedBox(width: 24),
                        _buildSocialLoginButton(
                          color: const Color(0xFF3B82F6),
                          icon: Icons.facebook,
                          onTap: () {
                            // QQ登录
                          },
                        ),
                        const SizedBox(width: 24),
                        _buildSocialLoginButton(
                          color: const Color(0xFFFACC15),
                          icon: Icons.info_outline,
                          onTap: () {
                            // 其他登录方式
                          },
                        ),
                      ],
                    ),
                    
                    // 底部协议提示
                    Padding(
                      padding: const EdgeInsets.only(top: 32, bottom: 24),
                      child: Text.rich(
                        TextSpan(
                          text: '登录即表示您同意我们的 ',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                          children: [
                            TextSpan(
                              text: '服务条款',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // 打开服务条款
                                },
                            ),
                            const TextSpan(text: ' 和 '),
                            TextSpan(
                              text: '隐私政策',
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
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建选项卡按钮
  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? AppTheme.primaryColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? AppTheme.primaryColor
                : const Color(0xFF6B7280),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// 构建社交登录按钮
  Widget _buildSocialLoginButton({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
} 