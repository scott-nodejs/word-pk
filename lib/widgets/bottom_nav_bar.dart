import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';

/// 底部导航栏组件
class BottomNavBar extends StatelessWidget {
  /// 当前选中的索引
  final int currentIndex;
  
  /// 索引变化回调
  final Function(int) onTap;
  
  /// 社区通知数量
  final int communityNotificationCount;
  
  /// 构造函数
  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.communityNotificationCount = AppConstants.defaultCommunityNotificationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFF3F4F6), // 更浅的灰色边框
            width: 1,
          ),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      height: 70, // 调整高度
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 底部导航栏的基本按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 首页按钮
              _buildNavButton(
                isActive: currentIndex == AppConstants.homeTabIndex,
                icon: Icons.arrow_upward_rounded,
                label: '首页',
                onTap: () => onTap(AppConstants.homeTabIndex),
              ),
              
              // 中间占位
              const SizedBox(width: 48),
              
              // 我的按钮
              _buildNavButton(
                isActive: currentIndex == AppConstants.profileTabIndex,
                icon: Icons.person_outline,
                label: '我的',
                onTap: () => onTap(AppConstants.profileTabIndex),
              ),
            ],
          ),
          
          // 对战按钮（中间凸起的按钮）
          Positioned(
            top: -20, // 向上凸起
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PulseAnimationEffect(
                  child: GestureDetector(
                    onTap: () => onTap(AppConstants.learningTabIndex),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF9333EA)], // indigo-500 to purple-600
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.bolt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '对战',
                  style: TextStyle(
                    fontSize: 12,
                    color: currentIndex == AppConstants.learningTabIndex
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF9CA3AF), // gray-400
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建普通导航按钮
  Widget _buildNavButton({
    required bool isActive,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive
                ? const Color(0xFF6366F1) // indigo-600
                : const Color(0xFF9CA3AF), // gray-400
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? const Color(0xFF6366F1) // indigo-600
                  : const Color(0xFF9CA3AF), // gray-400
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/// 脉冲动画效果
class PulseAnimationEffect extends StatefulWidget {
  final Widget child;

  const PulseAnimationEffect({Key? key, required this.child}) : super(key: key);

  @override
  State<PulseAnimationEffect> createState() => _PulseAnimationEffectState();
}

class _PulseAnimationEffectState extends State<PulseAnimationEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    // 安全启动动画，延迟到下一帧
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.stop(); // 确保先停止动画
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return widget.child; // 安全检查，如果组件已卸载则直接返回子组件
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.scale(
        scale: _animation.value,
        child: widget.child,
      ),
    );
  }
} 