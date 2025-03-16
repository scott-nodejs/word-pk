import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/answer_record.dart';
import '../screens/wrong_answers_screen.dart';

/// 单词挑战结果页面
class ChallengeResultScreen extends StatelessWidget {
  /// 答题记录列表
  final List<AnswerRecord> answerRecords;
  
  /// 总用时
  final Duration totalDuration;
  
  /// 总单词数
  final int totalWords;
  
  /// 构造函数
  const ChallengeResultScreen({
    Key? key,
    required this.answerRecords,
    required this.totalDuration,
    required this.totalWords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 计算正确数量和正确率
    final correctCount = answerRecords.where((record) => record.isCorrect).length;
    final correctRate = totalWords > 0 ? (correctCount / totalWords * 100).toInt() : 0;
    
    // 计算平均答题时间（秒）
    final totalSeconds = answerRecords.fold<int>(
      0, 
      (sum, record) => sum + record.duration.inMilliseconds,
    );
    final averageSeconds = answerRecords.isNotEmpty 
        ? (totalSeconds / answerRecords.length / 1000).toStringAsFixed(1) 
        : '0.0';
    
    // 格式化总用时（分钟）
    final minutes = (totalDuration.inSeconds / 60).toStringAsFixed(0);
    
    // 将正确和错误答案分组
    final correctAnswers = answerRecords.where((record) => record.isCorrect).toList();
    final wrongAnswers = answerRecords.where((record) => !record.isCorrect).toList();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 内容区域
            CustomScrollView(
              slivers: [
                // 顶部导航栏
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leadingWidth: 50,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    color: Colors.grey[700],
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: const Text(
                    '练习结果',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // TODO: 实现分享功能
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('分享功能开发中...')),
                        );
                      },
                      child: const Text(
                        '分享',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // 结果概览
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // 标题
                          const Text(
                            '恭喜完成练习！',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '你超过了85%的学习者',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // 统计数据
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('$correctRate%', '正确率'),
                              _buildStatItem('$totalWords', '单词数'),
                              _buildStatItem('${minutes}分', '用时'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // 正确答案
                if (correctAnswers.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        '正确答案 (${correctAnswers.length}个)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final record = correctAnswers[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: _buildCorrectAnswerCard(record),
                        );
                      },
                      childCount: correctAnswers.length > 2 ? 2 : correctAnswers.length, // 只显示前2个
                    ),
                  ),
                  if (correctAnswers.length > 2)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Text(
                          '还有${correctAnswers.length - 2}个正确答案...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
                
                // 错误答案
                if (wrongAnswers.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        '错误答案 (${wrongAnswers.length}个)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final record = wrongAnswers[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: _buildWrongAnswerCard(record),
                        );
                      },
                      childCount: wrongAnswers.length,
                    ),
                  ),
                ],
                
                // 学习建议
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.lightbulb_outline,
                              color: Color(0xFF3B82F6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '学习建议',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '建议重点关注错误的单词，可以通过例句和词组加深理解。同时可以尝试使用记忆技巧，提高记忆效果。',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // 练习数据
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[200]!,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildPracticeDataItem('85%', '平均正确率'),
                              ),
                              Expanded(
                                child: _buildPracticeDataItem('${averageSeconds}秒', '平均答题时间'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildPracticeDataItem('12天', '连续学习'),
                              ),
                              Expanded(
                                child: _buildPracticeDataItem('250词', '已掌握'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // 底部操作栏
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // 查看错题本按钮
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WrongAnswersScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.grey[700],
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '查看错题本',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // 继续练习按钮
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 关闭当前页面，返回到主页
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '继续练习',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
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
  
  /// 构建统计项
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
  
  /// 构建正确答案卡片
  Widget _buildCorrectAnswerCard(AnswerRecord record) {
    // 计算用时（秒）
    final seconds = (record.duration.inMilliseconds / 1000).toStringAsFixed(1);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.word,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                '${seconds}秒',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF059669),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            record.correctAnswer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建错误答案卡片
  Widget _buildWrongAnswerCard(AnswerRecord record) {
    // 计算用时（秒）
    final seconds = (record.duration.inMilliseconds / 1000).toStringAsFixed(1);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.word,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                '${seconds}秒',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.close,
                color: Color(0xFFDC2626),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '你的答案：${record.userAnswer}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check,
                color: Color(0xFF059669),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '正确答案：${record.correctAnswer}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 构建练习数据项
  Widget _buildPracticeDataItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
} 