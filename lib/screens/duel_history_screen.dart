import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../utils/mock_data.dart';
import '../widgets/gradient_background.dart';
import 'duel_detail_screen.dart';

/// 对战历史页面
class DuelHistoryScreen extends StatefulWidget {
  const DuelHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DuelHistoryScreen> createState() => _DuelHistoryScreenState();
}

class _DuelHistoryScreenState extends State<DuelHistoryScreen> {
  /// 当前选中的分类
  String _selectedCategory = '全部';
  
  /// 对战历史
  final _duelHistory = MockData.getDuelHistory();
  
  /// 统计数据
  final _stats = {
    'total': 32,
    'wins': 18,
    'winRate': 56,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildAppBar(),
            
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 统计卡片
                    _buildStatsCard(),
                    
                    // 分类标签
                    _buildCategoryTabs(),
                    
                    // 对战记录列表
                    _buildDuelList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 返回按钮和标题
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.chevron_left,
                  color: AppTheme.textSecondaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '对战历史',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          // 筛选按钮
          GestureDetector(
            onTap: () {
              // 显示筛选选项
            },
            child: const Icon(
              Icons.filter_list,
              color: AppTheme.textSecondaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建统计卡片
  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GradientBackground(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: 16,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '对战统计',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    value: _stats['total'].toString(),
                    label: '总场次',
                  ),
                  _buildStatItem(
                    value: _stats['wins'].toString(),
                    label: '胜场',
                  ),
                  _buildStatItem(
                    value: '${_stats['winRate']}%',
                    label: '胜率',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem({
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// 构建分类标签
  Widget _buildCategoryTabs() {
    final categories = ['全部', '胜利', '失败', '平局'];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = category == _selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 构建对战记录列表
  Widget _buildDuelList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _duelHistory.map((duel) {
          final isWinner = duel.player1Score > duel.player2Score;
          final isDraw = duel.player1Score == duel.player2Score;
          final pointsDelta = isWinner ? '+15' : (isDraw ? '+2' : '-8');
          
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DuelDetailScreen(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 对战信息
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 左侧信息
                      Row(
                        children: [
                          // 胜负标志
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isWinner
                                  ? const Color(0xFFD1FAE5)
                                  : (isDraw
                                      ? const Color(0xFFF3F4F6)
                                      : const Color(0xFFFEE2E2)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                isWinner ? '胜' : (isDraw ? '平' : '负'),
                                style: TextStyle(
                                  color: isWinner
                                      ? const Color(0xFF10B981)
                                      : (isDraw
                                          ? AppTheme.textSecondaryColor
                                          : const Color(0xFFEF4444)),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // 对手信息
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'vs. ${duel.player2.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '今天 14:30',
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDBEAFE),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      '四级词汇',
                                      style: TextStyle(
                                        color: Color(0xFF2563EB),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // 右侧比分
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${duel.player1Score}:${duel.player2Score}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            pointsDelta,
                            style: TextStyle(
                              color: isWinner
                                  ? const Color(0xFF10B981)
                                  : (isDraw
                                      ? AppTheme.textSecondaryColor
                                      : const Color(0xFFEF4444)),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 对战详情
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 左侧统计
                      Row(
                        children: [
                          // 平均时间
                          Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: AppTheme.textSecondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '平均5.2秒',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // 正确率
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 16,
                                color: AppTheme.textSecondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '正确率70%',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // 右侧详情按钮
                      TextButton(
                        onPressed: () {
                          // 查看详情
                        },
                        child: const Text(
                          '详情',
                          style: TextStyle(
                            color: Color(0xFF6366F1),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
} 