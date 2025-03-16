import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/wrong_answer.dart';
import '../utils/mock_data.dart';

/// 错题本页面
class WrongAnswersScreen extends StatefulWidget {
  /// 构造函数
  const WrongAnswersScreen({Key? key}) : super(key: key);

  @override
  State<WrongAnswersScreen> createState() => _WrongAnswersScreenState();
}

class _WrongAnswersScreenState extends State<WrongAnswersScreen> {
  /// 错题列表
  late List<WrongAnswer> _wrongAnswers;
  
  /// 已复习数量
  int _reviewedCount = 0;
  
  @override
  void initState() {
    super.initState();
    // 获取错题列表
    _wrongAnswers = MockData.getWrongAnswers();
    // 计算已复习数量
    _reviewedCount = _wrongAnswers.where((item) => item.isReviewed).length;
  }
  
  /// 标记全部已复习
  void _markAllAsReviewed() {
    setState(() {
      for (var answer in _wrongAnswers) {
        answer.isReviewed = true;
      }
      _reviewedCount = _wrongAnswers.length;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('所有错题已标记为已复习')),
    );
  }
  
  /// 删除错题
  void _deleteWrongAnswer(WrongAnswer answer) {
    setState(() {
      _wrongAnswers.remove(answer);
      if (answer.isReviewed) {
        _reviewedCount--;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('错题已删除')),
    );
  }
  
  /// 开始复习
  void _startReview() {
    // 获取未复习的错题
    final unreviewed = _wrongAnswers.where((answer) => !answer.isReviewed).toList();
    
    if (unreviewed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有未复习的错题')),
      );
      return;
    }
    
    // TODO: 跳转到复习页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('开始复习...')),
    );
  }
  
  /// 导出错题
  void _exportWrongAnswers() {
    // TODO: 导出错题功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('错题导出功能开发中...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 计算统计数据
    final totalCount = _wrongAnswers.length;
    final reviewedPercentage = totalCount > 0 ? (_reviewedCount / totalCount * 100).toInt() : 0;
    final thisWeekNewCount = _wrongAnswers.where(
      (item) => DateTime.now().difference(item.addedDate).inDays < 7
    ).length;
    
    // 按照日期分组
    final todayItems = _wrongAnswers.where(
      (item) => _isToday(item.addedDate)
    ).toList();
    
    final yesterdayItems = _wrongAnswers.where(
      (item) => _isYesterday(item.addedDate)
    ).toList();
    
    final earlierItems = _wrongAnswers.where(
      (item) => !_isToday(item.addedDate) && !_isYesterday(item.addedDate)
    ).toList();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
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
                    '错题本',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: _markAllAsReviewed,
                      child: const Text(
                        '全部标记已复习',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // 统计卡片
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFDB2777)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // 标题和总数
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '错题统计',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '本周新增：$thisWeekNewCount个',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$totalCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const Text(
                                    '总数',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // 进度条
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: reviewedPercentage,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 100 - reviewedPercentage,
                                  child: Container(),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // 已复习和百分比
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '已复习：$_reviewedCount个',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '$reviewedPercentage%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // 今天
                if (todayItems.isNotEmpty) ...[
                  _buildSectionHeader('今天'),
                  _buildWrongAnswersList(todayItems),
                ],
                
                // 昨天
                if (yesterdayItems.isNotEmpty) ...[
                  _buildSectionHeader('昨天'),
                  _buildWrongAnswersList(yesterdayItems),
                ],
                
                // 更早
                if (earlierItems.isNotEmpty) ...[
                  _buildSectionHeader('更早'),
                  _buildWrongAnswersList(earlierItems),
                ],
                
                // 底部间距，为底部操作栏留出空间
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
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
                    // 导出错题按钮
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _exportWrongAnswers,
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
                          '导出错题',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // 开始复习按钮
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _startReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '开始复习',
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
  
  /// 构建分组标题
  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建错题列表
  Widget _buildWrongAnswersList(List<WrongAnswer> items) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _buildWrongAnswerCard(item),
          );
        },
        childCount: items.length,
      ),
    );
  }
  
  /// 构建错题卡片
  Widget _buildWrongAnswerCard(WrongAnswer wrongAnswer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 单词和删除按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wrongAnswer.word,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      wrongAnswer.pronunciation,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (wrongAnswer.isReviewed)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '已复习',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[600],
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[400],
                        size: 22,
                      ),
                      onPressed: () => _deleteWrongAnswer(wrongAnswer),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 错误答案
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.close,
                  color: Colors.red[500],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '你的答案：${wrongAnswer.userAnswer}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red[500],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // 正确答案
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check,
                  color: Colors.green[500],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '正确答案：${wrongAnswer.correctAnswer}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[500],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 查看详情按钮
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // TODO: 跳转到单词详情页
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '查看详情',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 判断日期是否为今天
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
  
  /// 判断日期是否为昨天
  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }
} 