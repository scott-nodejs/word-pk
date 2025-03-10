import 'package:flutter/material.dart';
import 'action_button.dart';

/// 快捷操作面板组件
/// 
/// 提供继续学习和复习单词的按钮
class QuickActionsPanel extends StatelessWidget {
  /// 点击继续学习按钮的回调
  final VoidCallback onContinueLearning;
  
  /// 点击复习单词按钮的回调
  final VoidCallback onReviewWords;

  /// 构造函数
  const QuickActionsPanel({
    Key? key,
    required this.onContinueLearning,
    required this.onReviewWords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        children: [
          // 继续学习按钮
          Expanded(
            child: ActionButton(
              text: '继续学习',
              icon: Icons.book,
              onPressed: onContinueLearning,
              type: ActionButtonType.primary,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 复习单词按钮
          Expanded(
            child: ActionButton(
              text: '复习单词',
              icon: Icons.refresh,
              onPressed: onReviewWords,
              type: ActionButtonType.secondary,
            ),
          ),
        ],
      ),
    );
  }
} 