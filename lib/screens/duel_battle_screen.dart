import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/duel.dart';
import '../models/word_library.dart';
import '../utils/mock_data.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/progress_bar.dart';
import 'duel_result_screen.dart';

/// 双人PK对战页面
class DuelBattleScreen extends StatefulWidget {
  /// 词库
  final WordLibrary wordLibrary;
  
  /// 单词数量
  final int wordCount;
  
  /// 时间限制（秒）
  final int timeLimit;
  
  /// 构造函数
  const DuelBattleScreen({
    Key? key,
    required this.wordLibrary,
    required this.wordCount,
    required this.timeLimit,
  }) : super(key: key);

  @override
  State<DuelBattleScreen> createState() => _DuelBattleScreenState();
}

class _DuelBattleScreenState extends State<DuelBattleScreen> {
  /// 当前用户
  late final _currentUser = MockData.getCurrentUser();
  
  /// 对手用户
  late final _opponent = MockData.getDuelHistory().first.player2;
  
  /// 问题列表
  late final _questions = MockData.getDuelQuestions();
  
  /// 实际可用的题目数量
  late final int _actualWordCount;
  
  /// 当前问题索引
  int _currentIndex = 0;
  
  /// 当前用户得分
  int _userScore = 0;
  
  /// 对手得分
  int _opponentScore = 0;
  
  /// 剩余时间（秒）
  late int _remainingTime;
  
  /// 计时器
  Timer? _timer;
  
  /// 对手是否正在思考
  bool _isOpponentThinking = true;
  
  /// 对手思考计时器
  Timer? _opponentThinkingTimer;

  @override
  void initState() {
    super.initState();
    // 确保题目数量不超过实际可用题目数量
    _actualWordCount = widget.wordCount > _questions.length 
        ? _questions.length 
        : widget.wordCount;
    _remainingTime = widget.timeLimit;
    _startTimer();
    _simulateOpponentThinking();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _opponentThinkingTimer?.cancel();
    super.dispose();
  }

  /// 开始计时器
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          // 时间到，自动进入下一题
          _handleAnswer(-1); // -1表示未选择任何答案
        }
      });
    });
  }

  /// 模拟对手思考
  void _simulateOpponentThinking() {
    // 随机3-8秒后对手做出选择
    final thinkingTime = 3 + (DateTime.now().millisecondsSinceEpoch % 6);
    _opponentThinkingTimer = Timer(Duration(seconds: thinkingTime), () {
      if (mounted) {
        setState(() {
          _isOpponentThinking = false;
          // 随机决定对手是否答对
          final isCorrect = (DateTime.now().millisecondsSinceEpoch % 2) == 0;
          if (isCorrect) {
            _opponentScore++;
          }
        });
      }
    });
  }

  /// 处理答案选择
  void _handleAnswer(int selectedIndex) {
    // 检查是否超出题目范围
    if (_currentIndex >= _actualWordCount) {
      return;
    }
    
    final currentQuestion = _questions[_currentIndex];
    final isCorrect = selectedIndex == currentQuestion.correctOptionIndex;
    
    if (isCorrect) {
      setState(() {
        _userScore++;
      });
    }
    
    // 取消当前计时器
    _timer?.cancel();
    _opponentThinkingTimer?.cancel();
    
    // 延迟一段时间后进入下一题或结束
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_currentIndex < _actualWordCount - 1) {
        setState(() {
          _currentIndex++;
          _remainingTime = widget.timeLimit;
          _isOpponentThinking = true;
        });
        _startTimer();
        _simulateOpponentThinking();
      } else {
        // 对战结束，跳转到结果页面
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DuelResultScreen(
              userScore: _userScore,
              opponentScore: _opponentScore,
              wordLibrary: widget.wordLibrary,
              opponent: _opponent,
              questions: _questions.sublist(0, _actualWordCount),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 检查是否超出题目范围
    if (_currentIndex >= _actualWordCount) {
      return const Scaffold(
        body: Center(
          child: Text('题目加载错误'),
        ),
      );
    }
    
    final currentQuestion = _questions[_currentIndex];
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部状态栏
            _buildTopBar(),
            
            // 倒计时
            _buildCountdown(),
            
            // 单词卡片
            _buildWordCard(currentQuestion),
            
            // 选项列表
            _buildOptions(currentQuestion),
            
            // 对手状态
            _buildOpponentStatus(),
          ],
        ),
      ),
    );
  }

  /// 构建顶部状态栏
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // 用户信息和分数
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 当前用户
              Row(
                children: [
                  AvatarWidget(
                    initials: _currentUser.initials,
                    size: 40,
                    backgroundColor: Colors.white,
                    textColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentUser.name,
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
                            'Lv.${_currentUser.level}',
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
              
              // 题目进度
              Column(
                children: [
                  const Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '第 ${_currentIndex + 1}/$_actualWordCount 题',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              // 对手
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _opponent.name,
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
                            'Lv.${_opponent.level}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  AvatarWidget(
                    initials: _opponent.initials,
                    size: 40,
                    backgroundColor: Colors.white,
                    textColor: AppTheme.secondaryColor,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 得分进度条
          Row(
            children: [
              Text(
                '$_userScore',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DualProgressBar(
                  leftProgress: _userScore / widget.wordCount,
                  rightProgress: _opponentScore / widget.wordCount,
                  height: 8,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  leftColor: Colors.white,
                  rightColor: Colors.white,
                  borderRadius: 4,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_opponentScore',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建倒计时
  Widget _buildCountdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$_remainingTime',
              style: TextStyle(
                color: _remainingTime <= 5
                    ? Colors.red
                    : AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建单词卡片
  Widget _buildWordCard(DuelQuestion question) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // 单词
              Text(
                question.word,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // 音标
              Text(
                question.pronunciation,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // 发音按钮
              ElevatedButton(
                onPressed: () {
                  // 实际应用中，这里应该调用文本转语音API
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('播放发音...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E7FF),
                  foregroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.volume_up, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '发音',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  /// 构建选项列表
  Widget _buildOptions(DuelQuestion question) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.separated(
          itemCount: question.options.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final option = question.options[index];
            final optionLabel = String.fromCharCode(65 + index); // A, B, C, D...
            
            return GestureDetector(
              onTap: () => _handleAnswer(index),
              child: Container(
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
                child: Row(
                  children: [
                    // 选项标签
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          optionLabel,
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // 选项内容
                    Expanded(
                      child: Text(
                        option.text,
                        style: const TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 构建对手状态
  Widget _buildOpponentStatus() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: OpponentStatus(
        name: _opponent.name,
        initials: _opponent.initials,
        isThinking: _isOpponentThinking,
      ),
    );
  }
}

/// 思考动画点组件
class ThinkingDot extends StatefulWidget {
  const ThinkingDot({Key? key}) : super(key: key);

  @override
  State<ThinkingDot> createState() => _ThinkingDotState();
}

class _ThinkingDotState extends State<ThinkingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: AppTheme.textSecondaryColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// 对手状态组件
class OpponentStatus extends StatelessWidget {
  final String name;
  final String initials;
  final bool isThinking;

  const OpponentStatus({
    Key? key,
    required this.name,
    required this.initials,
    required this.isThinking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          AvatarWidget(
            initials: initials,
            size: 32,
            backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
            textColor: AppTheme.secondaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isThinking ? '$name 正在思考...' : '$name 已作答',
                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
                if (isThinking)
                  const Row(
                    children: [
                      ThinkingDot(),
                      SizedBox(width: 6),
                      ThinkingDot(),
                      SizedBox(width: 6),
                      ThinkingDot(),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 