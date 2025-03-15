import 'package:flutter/material.dart';
import 'dart:async';
import '../constants/app_theme.dart';

/// 开屏页面
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  /// 动画控制器
  late AnimationController _controller;
  late Animation<double> _animation;
  
  /// 倒计时
  int _countdown = 15;
  
  /// 定时器
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    
    // 延迟启动倒计时，确保页面渲染完成
    Future.delayed(const Duration(milliseconds: 500), () {
      // 倒计时
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_countdown > 0) {
          setState(() {
            _countdown--;
          });
        } else {
          timer.cancel();
          Navigator.pushReplacementNamed(context, '/main');
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 主体内容
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 应用标志
                FadeTransition(
                  opacity: _animation,
                  child: Stack(
                    children: [
                      // 主图标容器
                      Transform.rotate(
                        angle: 0.2, // 12度
                        child: Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF6366F1), // indigo-500
                                Color(0xFF9333EA), // purple-600
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu_book,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                      ),
                      // 右上角闪电图标
                      Positioned(
                        top: -8,
                        right: -8,
                        child: Transform.rotate(
                          angle: -0.2, // -12度
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFACC15),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.flash_on,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      // 左下角对勾图标
                      Positioned(
                        bottom: -8,
                        left: -8,
                        child: Transform.rotate(
                          angle: 0.8, // 45度
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Color(0xFF34D399),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // 应用名称
                FadeTransition(
                  opacity: _animation,
                  child: Column(
                    children: [
                      const Text(
                        'WordDuel',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 64,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '轻松学习，对战进步',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // 加载进度条
                SizedBox(
                  width: 192,
                  height: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: (15 - _countdown) / 15,  // 根据倒计时动态计算进度
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 底部连接状态
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // 连接状态
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '正在连接服务器... $_countdown',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                
                // 跳过按钮
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    _timer?.cancel();
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Text(
                      '跳过 $_countdown',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 装饰性圆点
          ...List.generate(6, (index) {
            final screenWidth = MediaQuery.of(context).size.width;
            final positions = [
              const Offset(40, 80),
              const Offset(80, 64),
              const Offset(64, 112),
              Offset(screenWidth - 40, 80),
              Offset(screenWidth - 80, 64),
              Offset(screenWidth - 64, 112),
            ];
            final sizes = [16.0, 8.0, 12.0, 12.0, 16.0, 8.0];
            final colors = [
              const Color(0xFFFFF7ED),
              const Color(0xFFEEF2FF),
              const Color(0xFFF5F3FF),
              const Color(0xFFECFDF5),
              const Color(0xFFEFF6FF),
              const Color(0xFFFDF2F8),
            ];
            
            return Positioned(
              left: positions[index].dx,
              top: positions[index].dy,
              child: Container(
                width: sizes[index],
                height: sizes[index],
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
} 