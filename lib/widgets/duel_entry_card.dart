import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';

/// 单词对决入口卡片组件
/// 
/// 提供对决模式的入口，具有渐变背景和按钮
class DuelEntryCard extends StatelessWidget {
  /// 点击卡片或按钮的回调
  final VoidCallback onTap;
  
  /// 卡片标题
  final String title;
  
  /// 卡片描述
  final String description;
  
  /// 按钮文本
  final String buttonText;
  
  /// 卡片背景渐变色
  final LinearGradient gradient;
  
  /// 图标
  final IconData icon;

  /// 构造函数
  const DuelEntryCard({
    Key? key,
    required this.onTap,
    this.title = '单词对决',
    this.description = '与好友一起PK，提升记忆效果',
    this.buttonText = '开始对决',
    this.icon = Icons.people,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GradientBackground(
        gradient: gradient,
        borderRadius: 16,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 左侧文本
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: onTap,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        foregroundColor: MaterialStateProperty.all(const Color(0xFF6366F1)),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(const Size(0, 32)),
                      ),
                      child: Text(buttonText),
                    ),
                  ],
                ),
              ),
              
              // 右侧图标
              _buildIconStack(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建右侧的图标堆叠效果
  Widget _buildIconStack() {
    return Stack(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFA78BFA),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF818CF8).withOpacity(0.5),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        SizedBox(
          width: 64,
          height: 64,
          child: Center(
            child: Icon(
              icon,
              color: Colors.white.withOpacity(0.9),
              size: 32,
            ),
          ),
        ),
      ],
    );
  }
} 