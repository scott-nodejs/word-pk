import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/user.dart';
import '../utils/mock_data.dart';
import 'word_challenge_screen.dart';

/// 单词挑战排行榜页面
class ChallengeLeaderboardScreen extends StatefulWidget {
  /// 构造函数
  const ChallengeLeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<ChallengeLeaderboardScreen> createState() => _ChallengeLeaderboardScreenState();
}

class _ChallengeLeaderboardScreenState extends State<ChallengeLeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 内容区域
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部导航
                  _buildTopBar(),
                  
                  // 挑战赛信息
                  _buildChallengeInfo(),
                  
                  // 排行榜
                  _buildLeaderboard(),
                  
                  // 挑战模式
                  _buildChallengeModes(),
                  
                  // 历史战绩
                  _buildHistory(),
                  
                  // 底部空间，为固定按钮留出空间
                  const SizedBox(height: 80),
                ],
              ),
            ),
            
            // 底部固定按钮
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomButton(),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建顶部导航栏
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 返回按钮和标题
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: Colors.grey[500],
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              const Text(
                '单词挑战赛',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          
          // 规则说明按钮
          TextButton(
            onPressed: () {
              // 显示规则说明
              _showRulesDialog();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '规则说明',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建挑战赛信息卡片
  Widget _buildChallengeInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
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
            // 标题和奖金池
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '每周单词王',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '第32期 · 还剩3天结束',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '奖金池：￥1280',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 统计数据
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildChallengeStatItem('128', '参与人数'),
                _buildChallengeStatItem('500', '单词数量'),
                _buildChallengeStatItem('3', '挑战轮次'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建挑战赛统计项
  Widget _buildChallengeStatItem(String value, String label) {
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
  
  /// 构建排行榜部分
  Widget _buildLeaderboard() {
    // 假设的前三名用户数据
    final topUsers = [
      _LeaderboardUser(
        rank: 1,
        name: 'Michael Chen',
        avatarUrl: 'avatar2.jpg',
        score: 980,
        scoreChange: 15,
        isPositiveChange: true,
      ),
      _LeaderboardUser(
        rank: 2,
        name: 'Sarah Wilson',
        avatarUrl: 'avatar3.jpg',
        score: 920,
        scoreChange: 8,
        isPositiveChange: false,
      ),
      _LeaderboardUser(
        rank: 3,
        name: 'David Wang',
        avatarUrl: 'avatar4.jpg',
        score: 880,
        scoreChange: 20,
        isPositiveChange: true,
      ),
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 标题和查看全部按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '排行榜',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: 查看完整排行榜
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '查看全部 >',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 排行榜列表
          ...topUsers.map((user) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildLeaderboardUserItem(user),
          )).toList(),
        ],
      ),
    );
  }
  
  /// 构建排行榜用户项
  Widget _buildLeaderboardUserItem(_LeaderboardUser user) {
    // 根据排名确定样式
    Color rankBgColor;
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;
    
    switch (user.rank) {
      case 1:
        rankBgColor = const Color(0xFFFBBF24); // 金色
        badgeBgColor = const Color(0xFFFEF3C7);
        badgeTextColor = const Color(0xFFD97706);
        badgeText = '第一名';
        break;
      case 2:
        rankBgColor = Colors.grey[400]!; // 银色
        badgeBgColor = Colors.grey[100]!;
        badgeTextColor = Colors.grey[600]!;
        badgeText = '第二名';
        break;
      case 3:
        rankBgColor = const Color(0xFFB45309); // 铜色
        badgeBgColor = const Color(0xFFFBBF24).withOpacity(0.1);
        badgeTextColor = const Color(0xFFB45309);
        badgeText = '第三名';
        break;
      default:
        rankBgColor = Colors.grey[300]!;
        badgeBgColor = Colors.grey[100]!;
        badgeTextColor = Colors.grey[600]!;
        badgeText = '第${user.rank}名';
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 排名
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${user.rank}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 头像
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.name.substring(0, 1),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '得分：${user.score}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${user.isPositiveChange ? '+' : '-'}${user.scoreChange}',
                      style: TextStyle(
                        fontSize: 12,
                        color: user.isPositiveChange ? Colors.green[600] : Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 排名标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建挑战模式部分
  Widget _buildChallengeModes() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '挑战模式',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 挑战模式卡片
          Row(
            children: [
              // 限时挑战
              Expanded(
                child: _buildChallengeModeCard(
                  iconData: Icons.timer,
                  iconColor: const Color(0xFF3B82F6),
                  iconBgColor: const Color(0xFFDBEAFE),
                  title: '限时挑战',
                  description: '10分钟内完成100个单词',
                  buttonText: '开始挑战',
                  buttonColor: const Color(0xFFEFF6FF),
                  buttonTextColor: const Color(0xFF3B82F6),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WordChallengeScreen(),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 12),
              
              // 好友对战
              Expanded(
                child: _buildChallengeModeCard(
                  iconData: Icons.group,
                  iconColor: const Color(0xFF8B5CF6),
                  iconBgColor: const Color(0xFFEDE9FE),
                  title: '好友对战',
                  description: '邀请好友一起比赛',
                  buttonText: '发起对战',
                  buttonColor: const Color(0xFFF5F3FF),
                  buttonTextColor: const Color(0xFF8B5CF6),
                  onTap: () {
                    // TODO: 实现好友对战功能
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('好友对战功能开发中...')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 构建挑战模式卡片
  Widget _buildChallengeModeCard({
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    required String buttonText,
    required Color buttonColor,
    required Color buttonTextColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图标
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 24,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 标题
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
          
          const SizedBox(height: 4),
          
          // 描述
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 按钮
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建历史战绩部分
  Widget _buildHistory() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '历史战绩',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: 查看全部历史战绩
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '查看全部 >',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 战绩卡片 - 胜利
          _buildHistoryCard(
            isWin: true,
            challengeType: '限时挑战',
            date: '7月28日 15:30',
            score: 95,
            rank: '3/50',
            accuracy: '95%',
            duration: '8分30秒',
            wordCount: '100词',
          ),
          
          const SizedBox(height: 12),
          
          // 战绩卡片 - 失败
          _buildHistoryCard(
            isWin: false,
            challengeType: '好友对战',
            date: '7月27日 20:15',
            score: 85,
            rank: null,
            accuracy: '85%',
            duration: '9分45秒',
            wordCount: '95词',
            opponentScore: '92',
          ),
        ],
      ),
    );
  }
  
  /// 构建历史战绩卡片
  Widget _buildHistoryCard({
    required bool isWin,
    required String challengeType,
    required String date,
    required int score,
    String? rank,
    String? opponentScore,
    required String accuracy,
    required String duration,
    required String wordCount,
  }) {
    final resultBgColor = isWin ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
    final resultTextColor = isWin ? const Color(0xFF059669) : const Color(0xFFDC2626);
    final resultText = isWin ? '胜' : '负';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 头部信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 左侧 - 结果和挑战类型
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: resultBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        resultText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: resultTextColor,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challengeType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // 右侧 - 分数和排名
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '得分：$score',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rank != null ? '排名：$rank' : '对手：${opponentScore}分',
                    style: TextStyle(
                      fontSize: 12,
                      color: rank != null ? (isWin ? Colors.green[600] : Colors.grey[500]) : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 统计信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '正确率：$accuracy',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                '用时：$duration',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                '完成：$wordCount',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 构建底部按钮
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WordChallengeScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '参加本期挑战',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  /// 显示规则说明对话框
  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('单词挑战赛规则'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('1. 每期挑战赛持续一周时间'),
              SizedBox(height: 8),
              Text('2. 限时挑战模式：在10分钟内完成100个单词的挑战'),
              SizedBox(height: 8),
              Text('3. 每道题有4个选项，选择单词的正确含义'),
              SizedBox(height: 8),
              Text('4. 答错3次后挑战结束'),
              SizedBox(height: 8),
              Text('5. 根据正确题数和答题速度计算得分'),
              SizedBox(height: 8),
              Text('6. 每位用户每天有3次挑战机会'),
              SizedBox(height: 8),
              Text('7. 周末结算排名，前三名将获得奖励'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('了解了'),
          ),
        ],
      ),
    );
  }
}

/// 排行榜用户类
class _LeaderboardUser {
  final int rank;
  final String name;
  final String avatarUrl;
  final int score;
  final int scoreChange;
  final bool isPositiveChange;
  
  _LeaderboardUser({
    required this.rank,
    required this.name,
    required this.avatarUrl,
    required this.score,
    required this.scoreChange,
    required this.isPositiveChange,
  });
} 