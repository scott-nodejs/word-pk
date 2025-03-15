import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/gradient_background.dart';

/// 对战排行榜页面
class DuelRankingScreen extends StatefulWidget {
  const DuelRankingScreen({Key? key}) : super(key: key);

  @override
  State<DuelRankingScreen> createState() => _DuelRankingScreenState();
}

class _DuelRankingScreenState extends State<DuelRankingScreen> {
  String _selectedCategory = '全部';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部导航栏
              _buildAppBar(),
              
              // 我的排名
              _buildMyRanking(),
              
              // 分类标签
              _buildCategoryTabs(),
              
              // 排行榜列表
              _buildRankingList(),
            ],
          ),
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
                '对战排行榜',
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
              // 打开筛选选项
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

  /// 构建我的排名卡片
  Widget _buildMyRanking() {
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
                '我的排名',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 用户信息
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            'JD',
                            style: TextStyle(
                              color: const Color(0xFF6366F1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'John Doe',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFD700),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Lv.8',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // 排名信息
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '第8名',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '1250分',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建分类标签
  Widget _buildCategoryTabs() {
    final categories = ['全部', '好友', '四级词汇', '六级词汇'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: categories.map((category) {
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
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
    );
  }

  /// 构建排行榜列表
  Widget _buildRankingList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildRankingItem(
            rank: 1,
            avatar: 'SK',
            name: 'Sarah Kim',
            level: 7,
            score: 1865,
            winRate: 78,
            avatarColor: const Color(0xFFFFF7ED),
            textColor: const Color(0xFFC2410C),
            rankColor: const Color(0xFFF59E0B),
          ),
          _buildRankingItem(
            rank: 2,
            avatar: 'MJ',
            name: 'Mike Johnson',
            level: 9,
            score: 1720,
            winRate: 72,
            avatarColor: const Color(0xFFF3F4F6),
            textColor: const Color(0xFF4B5563),
            rankColor: const Color(0xFF9CA3AF),
          ),
          _buildRankingItem(
            rank: 3,
            avatar: 'EW',
            name: 'Emma Wilson',
            level: 8,
            score: 1650,
            winRate: 68,
            avatarColor: const Color(0xFFFFF7ED),
            textColor: const Color(0xFFC2410C),
            rankColor: const Color(0xFFF97316),
          ),
          // 其他排名项...
          _buildRankingItem(
            rank: 8,
            avatar: 'JD',
            name: 'John Doe',
            level: 8,
            score: 1250,
            winRate: 58,
            isCurrentUser: true,
          ),
        ],
      ),
    );
  }

  /// 构建排行榜项
  Widget _buildRankingItem({
    required int rank,
    required String avatar,
    required String name,
    required int level,
    required int score,
    required int winRate,
    Color? avatarColor,
    Color? textColor,
    Color? rankColor,
    bool isCurrentUser = false,
  }) {
    final defaultAvatarColor = const Color(0xFFF3F4F6);
    final defaultTextColor = const Color(0xFF4B5563);
    final defaultRankColor = const Color(0xFF9CA3AF);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? const Color(0xFFEEF2FF)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser
              ? const Color(0xFFE0E7FF)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // 排名
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: (rank <= 3 ? rankColor : defaultRankColor)?.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    rank.toString(),
                    style: TextStyle(
                      color: rank <= 3 ? rankColor : defaultTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // 头像
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: avatarColor ?? defaultAvatarColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    avatar,
                    style: TextStyle(
                      color: textColor ?? defaultTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // 用户信息
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFD700),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Lv.$level',
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          // 分数和胜率
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score分',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '胜率 $winRate%',
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 