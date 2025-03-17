import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../services/word_service.dart';

/// 忘记密码页面
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  /// 当前步骤（1-3）
  int _currentStep = 1;
  
  /// 手机号Controller
  final TextEditingController _phoneController = TextEditingController();
  
  /// 验证码Controller
  final TextEditingController _verifyCodeController = TextEditingController();
  
  /// 新密码Controller
  final TextEditingController _newPasswordController = TextEditingController();
  
  /// 确认密码Controller
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  /// 是否显示新密码
  bool _showNewPassword = false;
  
  /// 是否显示确认密码
  bool _showConfirmPassword = false;
  
  /// 是否正在加载
  bool _isLoading = false;
  
  /// 验证码倒计时
  int _countDown = 0;
  
  /// 单词服务
  final _wordService = WordService();
  
  @override
  void dispose() {
    _phoneController.dispose();
    _verifyCodeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
        type: 'reset',
      );
      
      if (!success) {
        _showMessage('验证码发送失败，请稍后重试');
      }
    } catch (e) {
      _showMessage('发送验证码失败: $e');
    }
  }
  
  /// 验证验证码
  Future<void> _verifyCode() async {
    if (_phoneController.text.isEmpty) {
      _showMessage('请输入手机号');
      return;
    }
    
    if (_verifyCodeController.text.isEmpty) {
      _showMessage('请输入验证码');
      return;
    }
    
    // 这里只是简单地进入下一步，实际应用中可能需要验证验证码是否正确
    setState(() {
      _currentStep = 2;
    });
  }
  
  /// 重置密码
  Future<void> _resetPassword() async {
    if (_newPasswordController.text.isEmpty) {
      _showMessage('请输入新密码');
      return;
    }
    
    if (_confirmPasswordController.text.isEmpty) {
      _showMessage('请确认新密码');
      return;
    }
    
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showMessage('两次输入的密码不一致');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await _wordService.resetPassword(
        _phoneController.text,
        _newPasswordController.text,
        _verifyCodeController.text,
      );
      
      if (success) {
        setState(() {
          _currentStep = 3;
          _isLoading = false;
        });
      } else {
        _showMessage('重置密码失败，请稍后重试');
      }
    } catch (e) {
      _showMessage('重置密码失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        child: Column(
          children: [
            // 顶部导航
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFF3F4F6),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '找回密码',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),

            // 步骤指示器
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  _buildStepIndicator(1, '验证手机'),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 4,
                          color: const Color(0xFFF3F4F6),
                        ),
                        Container(
                          height: 4,
                          color: AppTheme.primaryColor,
                          width: _currentStep > 1 ? double.infinity : 0,
                        ),
                      ],
                    ),
                  ),
                  _buildStepIndicator(2, '重置密码'),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 4,
                          color: const Color(0xFFF3F4F6),
                        ),
                        Container(
                          height: 4,
                          color: AppTheme.primaryColor,
                          width: _currentStep > 2 ? double.infinity : 0,
                        ),
                      ],
                    ),
                  ),
                  _buildStepIndicator(3, '完成'),
                ],
              ),
            ),

            // 表单内容
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '请输入您注册时使用的手机号码，我们将发送验证码至该手机',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
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
                          onPressed: () {
                            // 获取验证码
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            '获取验证码',
                            style: TextStyle(
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

                  // 下一步按钮
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentStep = 2;
                      });
                      // TODO: 实现下一步逻辑
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                    ),
                    child: const Text(
                      '下一步',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建步骤指示器项
  Widget _buildStepIndicator(int step, String label) {
    final isActive = step <= _currentStep;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryColor : const Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppTheme.primaryColor : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
} 