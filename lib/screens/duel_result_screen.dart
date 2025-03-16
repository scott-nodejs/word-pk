import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/duel.dart';
import '../models/user.dart';
import '../models/word_library.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/gradient_background.dart';
import 'duel_matching_screen.dart';
import 'learning_screen.dart';

/// 双人PK结果页面
class DuelResultScreen extends StatelessWidget {
  /// 用户得分
  final int userScore;
  
  /// 对手得分
  final int opponentScore;
  
  /// 词库
  final WordLibrary wordLibrary;
  
  /// 对手
  final User opponent;
  
  /// 问题列表
  final List<DuelQuestion> questions;
  
  /// 构造函数
  const DuelResultScreen({
    Key? key,
    required this.userScore,
    required this.opponentScore,
    required this.wordLibrary,
    required this.opponent,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWinner = userScore > opponentScore;
    final isDraw = userScore == opponentScore;
    final currentUser = User(
      id: 'user1',
      name: 'John Doe',
      initials: 'JD',
      level: 8,
      score: 3500,
    );
    
    // 计算错题列表
    final wrongQuestions = _getWrongQuestions();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildAppBar(context),
            
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 结果展示
                      _buildResultSection(context, isWinner, isDraw, currentUser),
                      
                      // 详细数据
                      _buildStatsSection(),
                      
                      // 错题回顾
                      if (wrongQuestions.isNotEmpty)
                        _buildWrongQuestionsSection(wrongQuestions),
                      
                      // 操作按钮
                      _buildActionButtons(context),
                      
                      // 底部间距
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildAppBar(BuildContext context) {
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
                '对决结果',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          // 分享按钮
          GestureDetector(
            onTap: () {
              // 分享结果
            },
            child: const Icon(
              Icons.share,
              color: AppTheme.textSecondaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建结果展示部分
  Widget _buildResultSection(
    BuildContext context,
    bool isWinner,
    bool isDraw,
    User currentUser,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: GradientBackground(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: 16,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // 结果标题
              Text(
                isDraw ? '平局！' : (isWinner ? '胜利！' : '失败！'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isDraw
                    ? '双方实力相当'
                    : (isWinner ? '恭喜你赢得了这场对决' : '继续努力，下次一定能赢'),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              
              // 用户信息和分数
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 当前用户
                  Column(
                    children: [
                      AvatarWidget(
                        initials: currentUser.initials,
                        size: 64,
                        backgroundColor: Colors.white,
                        textColor: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentUser.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Lv.${currentUser.level}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // 分数
                  Column(
                    children: [
                      const Text(
                        'VS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$userScore : $opponentScore',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      const Text(
                        '得分',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  // 对手
                  Column(
                    children: [
                      AvatarWidget(
                        initials: opponent.initials,
                        size: 64,
                        backgroundColor: Colors.white,
                        textColor: AppTheme.secondaryColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        opponent.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Lv.${opponent.level}',
                            style: const TextStyle(
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
              
              const SizedBox(height: 24),
              
              // 奖励信息
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '经验值',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        const Text(
                          '+120 XP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '排名积分',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          isWinner ? '+15' : '-8',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建详细数据部分
  Widget _buildStatsSection() {
    // 计算统计数据
    final correctRate = userScore / questions.length * 100;
    const avgTime = 5.2; // 秒
    const fastestTime = 2.8; // 秒
    const consecutiveCorrect = 5; // 题
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '对决数据',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Container(
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
                Row(
                  children: [
                    _buildStatItem('正确率', '${correctRate.toStringAsFixed(0)}%', AppTheme.primaryColor),
                    _buildStatItem('平均用时', '${avgTime}秒', AppTheme.primaryColor),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatItem('最快答题', '${fastestTime}秒', AppTheme.primaryColor),
                    _buildStatItem('连续正确', '${consecutiveCorrect}题', AppTheme.primaryColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建错题回顾部分
  Widget _buildWrongQuestionsSection(List<DuelQuestion> wrongQuestions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '错题回顾',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: wrongQuestions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final question = wrongQuestions[index];
              final correctOption = question.options[question.correctOptionIndex];
              
              return Container(
                padding: const EdgeInsets.all(12),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 单词和错误标签
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          question.word,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimaryColor,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '答错',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // 正确释义
                    Text(
                      '正确释义: ${correctOption.text}',
                      style: const TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // 用户选择
                    Text(
                      '你的选择: ${_getWrongAnswer(question)}',
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // 再来一局按钮
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DuelMatchingScreen(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.refresh, size: 20),
                SizedBox(width: 8),
                Text('再来一局'),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // 学习错题按钮
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LearningScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.book, size: 20),
                SizedBox(width: 8),
                Text('学习错题'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 获取错题列表
  List<DuelQuestion> _getWrongQuestions() {
    // 模拟错题，实际应用中应该根据用户的答题记录来获取
    return questions.where((q) => 
      q.word == 'Ambiguous' || 
      q.word == 'Eloquent' || 
      q.word == 'Meticulous'
    ).toList();
  }

  /// 获取错误答案
  String _getWrongAnswer(DuelQuestion question) {
    // 模拟错误答案，实际应用中应该根据用户的答题记录来获取
    if (question.word == 'Ambiguous') {
      return '雄心勃勃的，有野心的';
    } else if (question.word == 'Eloquent') {
      return '优雅的，高贵的';
    } else if (question.word == 'Meticulous') {
      return '善变的，多变的';
    }
    return '';
  }
} 