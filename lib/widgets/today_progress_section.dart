import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import 'progress_bar.dart';

/// 今日学习进度组件
/// 
/// 显示用户今日学习的进度和相关统计数据
class TodayProgressSection extends StatelessWidget {
  /// 今日进度百分比（0.0-1.0）
  final double progress;
  
  /// 已学单词数
  final int learnedWords;
  
  /// 待学单词数
  final int wordsToLearn;
  
  /// 待复习单词数
  final int wordsToReview;

  /// 构造函数
  const TodayProgressSection({
    Key? key,
    required this.progress,
    required this.learnedWords,
    required this.wordsToLearn,
    required this.wordsToReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和进度百分比
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '今日进度',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                  fontSize: 16,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 进度条
          ProgressBar(
            progress: progress,
            height: 10,
            borderRadius: 5,
            progressColor: AppTheme.primaryColor,
          ),
          
          const SizedBox(height: 12),
          
          // 进度详情
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressItem('已学', learnedWords, AppTheme.primaryColor),
              _buildProgressItem('待学', wordsToLearn, AppTheme.primaryColor),
              _buildProgressItem('待复习', wordsToReview, AppTheme.primaryColor),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建进度项
  Widget _buildProgressItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
} 