import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word_library.dart';
import '../utils/mock_data.dart';
import '../widgets/gradient_background.dart';
import '../widgets/library_card.dart';
import 'duel_battle_screen.dart';
import 'duel_history_screen.dart';
import 'duel_ranking_screen.dart';
import 'study_statistics_screen.dart';

/// 双人PK匹配页面
class DuelMatchingScreen extends StatefulWidget {
  /// 构造函数
  const DuelMatchingScreen({Key? key}) : super(key: key);

  @override
  State<DuelMatchingScreen> createState() => _DuelMatchingScreenState();
}

class _DuelMatchingScreenState extends State<DuelMatchingScreen> {
  /// 选中的词库
  WordLibrary? _selectedLibrary;
  
  /// 单词数量
  int _wordCount = 10;
  
  /// 时间限制（秒）
  int _timeLimit = 15;
  
  /// 对战历史
  final _duelHistory = MockData.getDuelHistory();
  
  /// 当前选择的对战模式
  DuelMode _selectedMode = DuelMode.random;

  @override
  void initState() {
    super.initState();
    // 默认选择第一个词库
    _selectedLibrary = MockData.getWordLibraries().first;
  }

  /// 开始匹配
  void _startMatching() {
    // 显示匹配中对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _MatchingDialog(),
    );
    
    // 模拟匹配过程，2秒后跳转到对战页面
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // 如果组件已销毁，则不执行导航操作
      
      // 获取对话框的context，用于关闭对话框
      final navigatorContext = Navigator.of(context).context;
      if (navigatorContext.mounted) {
        Navigator.pop(navigatorContext); // 关闭匹配对话框
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DuelBattleScreen(
              wordLibrary: _selectedLibrary!,
              wordCount: _wordCount,
              timeLimit: _timeLimit,
            ),
          ),
        );
      }
    });
  }

  /// 开始当面PK
  void _startFaceToFaceDuel() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _FaceToFaceDuelDialog(
        onCodeConfirmed: (code) {
          // 模拟匹配过程，2秒后跳转到对战页面
          if (!mounted) return; // 如果组件已销毁，则不执行导航操作
          
          // 获取对话框的context，用于关闭对话框
          final dialogContext = Navigator.of(context).context;
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext); // 关闭对话框
            
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => _MatchingDialog(
                title: '已找到对手',
                subtitle: '准备开始对战...',
              ),
            );
            
            Future.delayed(const Duration(seconds: 2), () {
              if (!mounted) return; // 再次检查组件是否已销毁
              
              // 获取匹配对话框的context
              final matchingDialogContext = Navigator.of(context).context;
              if (matchingDialogContext.mounted) {
                Navigator.pop(matchingDialogContext); // 关闭匹配对话框
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DuelBattleScreen(
                      wordLibrary: _selectedLibrary!,
                      wordCount: _wordCount,
                      timeLimit: _timeLimit,
                    ),
                  ),
                );
              }
            });
          }
        },
      ),
    );
  }

  /// 调整单词数量
  void _adjustWordCount(int delta) {
    setState(() {
      _wordCount = (_wordCount + delta).clamp(5, 20);
    });
  }

  /// 调整时间限制
  void _adjustTimeLimit(int delta) {
    setState(() {
      _timeLimit = (_timeLimit + delta).clamp(5, 30);
    });
  }

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 对决模式选择
                      _buildDuelModeSection(),
                      
                      // 词库选择
                      _buildLibrarySelection(),
                      
                      // 对决设置
                      _buildDuelSettings(),
                      
                      // 开始按钮
                      _buildStartButton(),
                      
                      // 历史对决
                      _buildDuelHistory(),
                      
                      // 学习概览
                      _buildOverview(),
                      
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
                '单词对决',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          // 帮助按钮
          GestureDetector(
            onTap: () {
              // 显示帮助信息
            },
            child: const Icon(
              Icons.help_outline,
              color: AppTheme.textSecondaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建对决模式选择部分
  Widget _buildDuelModeSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择对决模式',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          // 三个对决模式横向排列
          Row(
            children: [
              // 随机匹配
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMode = DuelMode.random;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: GradientBackground(
                      gradient: LinearGradient(
                        colors: _selectedMode == DuelMode.random
                            ? const [Color(0xFF6366F1), Color(0xFF4F46E5)]
                            : [const Color(0xFF6366F1).withOpacity(0.7), const Color(0xFF4F46E5).withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: 16,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '随机匹配',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // 好友对决
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMode = DuelMode.friend;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: GradientBackground(
                      gradient: LinearGradient(
                        colors: _selectedMode == DuelMode.friend
                            ? const [Color(0xFFA855F7), Color(0xFF9333EA)]
                            : [const Color(0xFFA855F7).withOpacity(0.7), const Color(0xFF9333EA).withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: 16,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.people_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '好友对决',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // 当面PK
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMode = DuelMode.faceToFace;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: GradientBackground(
                      gradient: LinearGradient(
                        colors: _selectedMode == DuelMode.faceToFace
                            ? const [Color(0xFF10B981), Color(0xFF059669)]
                            : [const Color(0xFF10B981).withOpacity(0.7), const Color(0xFF059669).withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: 16,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.near_me,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '新',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '当面PK',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建词库选择部分
  Widget _buildLibrarySelection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择对决词库',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // 打开词库选择对话框
              _showLibrarySelectionDialog();
            },
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
                  // 词库信息
                  Expanded(
                    child: Row(
                      children: [
                        // 词库图标
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBEAFE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'CET',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // 词库名称和描述
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedLibrary?.name ?? '大学英语四级',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimaryColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_selectedLibrary?.wordCount ?? 2500}词 | 难度: ${_selectedLibrary?.difficulty ?? '中等'}',
                              style: const TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // 下拉箭头
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.textSecondaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建对决设置部分
  Widget _buildDuelSettings() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '对决设置',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          // 单词数量设置
          _buildSettingItem(
            title: '单词数量',
            subtitle: '每轮对决的单词数量',
            value: '$_wordCount',
            onDecrease: () => _adjustWordCount(-5),
            onIncrease: () => _adjustWordCount(5),
          ),
          const SizedBox(height: 16),
          // 时间限制设置
          _buildSettingItem(
            title: '时间限制',
            subtitle: '每个单词的答题时间',
            value: '$_timeLimit秒',
            onDecrease: () => _adjustTimeLimit(-5),
            onIncrease: () => _adjustTimeLimit(5),
          ),
        ],
      ),
    );
  }

  /// 构建设置项
  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Row(
      children: [
        // 标题和副标题
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimaryColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        
        // 调整按钮和数值
        Row(
          children: [
            // 减少按钮
            GestureDetector(
              onTap: onDecrease,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.remove,
                  color: AppTheme.textSecondaryColor,
                  size: 20,
                ),
              ),
            ),
            
            // 数值
            SizedBox(
              width: 60,
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimaryColor,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // 增加按钮
            GestureDetector(
              onTap: onIncrease,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.add,
                  color: AppTheme.textSecondaryColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建开始按钮
  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _selectedMode == DuelMode.faceToFace ? _startFaceToFaceDuel : _startMatching,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _selectedMode == DuelMode.faceToFace ? '开始当面PK' : '开始匹配',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建对战历史部分
  Widget _buildDuelHistory() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '对战历史',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              // 使用更简单的按钮布局
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DuelRankingScreen(),
                    ),
                  );
                },
                child: const Text(
                  '排行榜',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DuelHistoryScreen(),
                    ),
                  );
                },
                child: const Text(
                  '全部',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 历史对决列表
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _duelHistory.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final duel = _duelHistory[index];
              final isWinner = duel.player1Score > duel.player2Score;
              final opponent = duel.player2;
              final score = duel.player1Score;
              final pointsDelta = isWinner ? '+15' : '-8';
              final time = index == 0 ? '今天 14:30' : '昨天 18:45';
              
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
                child: Row(
                  children: [
                    // 胜负标志
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isWinner
                            ? const Color(0xFFD1FAE5)
                            : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          isWinner ? '胜' : '负',
                          style: TextStyle(
                            color: isWinner
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // 对战信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'vs. ${opponent.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$time | 得分: $score',
                            style: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 积分变化
                    Text(
                      pointsDelta,
                      style: TextStyle(
                        color: isWinner
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
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

  /// 显示词库选择对话框
  void _showLibrarySelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择词库'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: MockData.getWordLibraries().length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final library = MockData.getWordLibraries()[index];
                return ListTile(
                  title: Text(library.name),
                  subtitle: Text('${library.wordCount}词 | 难度: ${library.difficulty}'),
                  onTap: () {
                    setState(() {
                      _selectedLibrary = library;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  /// 构建学习概览
  Widget _buildOverview() {
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
                '本月学习概览',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudyStatisticsScreen(),
                        ),
                      );
                    },
                    child: _buildOverviewItem('28天', '学习天数'),
                  ),
                  _buildOverviewItem('420个', '学习单词'),
                  _buildOverviewItem('18小时', '学习时长'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建学习概览项
  Widget _buildOverviewItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// 匹配中对话框
class _MatchingDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  
  const _MatchingDialog({
    Key? key, 
    this.title = '正在匹配对手...',
    this.subtitle = '请稍候片刻',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// 当面PK对话框
class _FaceToFaceDuelDialog extends StatefulWidget {
  final Function(String) onCodeConfirmed;
  
  const _FaceToFaceDuelDialog({
    Key? key,
    required this.onCodeConfirmed,
  }) : super(key: key);

  @override
  State<_FaceToFaceDuelDialog> createState() => _FaceToFaceDuelDialogState();
}

class _FaceToFaceDuelDialogState extends State<_FaceToFaceDuelDialog> {
  final List<String> _codeDigits = ['', '', '', ''];
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  bool _isWaiting = false;
  int _countdown = 60;
  Timer? _timer;
  bool _isDisposed = false;
  
  @override
  void initState() {
    super.initState();
    // 自动聚焦第一个输入框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        FocusScope.of(context).requestFocus(_focusNodes[0]);
      }
    });
  }
  
  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  void _startCountdown() {
    if (_isDisposed) return;
    
    setState(() {
      _isWaiting = true;
      _countdown = 60;
    });
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isDisposed && _countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        if (!_isDisposed) {
          _resetForm();
        }
      }
    });
    
    // 模拟匹配成功，5秒后返回结果
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isDisposed && mounted) {
        _timer?.cancel();
        final code = _codeDigits.join();
        widget.onCodeConfirmed(code);
      }
    });
  }
  
  void _resetForm() {
    setState(() {
      _isWaiting = false;
      for (var i = 0; i < 4; i++) {
        _codeDigits[i] = '';
        _controllers[i].clear();
      }
    });
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }
  
  void _checkAndProceed() {
    // 检查是否所有数字都已输入
    if (_codeDigits.every((digit) => digit.isNotEmpty)) {
      // 开始计时等待匹配
      _startCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('当面PK'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '请双方在一定范围内同时输入4位数字匹配码',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // 四位数字输入框
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return SizedBox(
                width: 40,
                height: 48,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  enabled: !_isWaiting,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.primaryColor),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _codeDigits[index] = value;
                      });
                      
                      // 自动跳到下一个输入框
                      if (index < 3) {
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      } else {
                        // 最后一个输入框，隐藏键盘
                        FocusScope.of(context).unfocus();
                        _checkAndProceed();
                      }
                    }
                  },
                ),
              );
            }),
          ),
          
          if (_isWaiting) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '正在等待匹配 ($_countdown)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
        if (_isWaiting)
          TextButton(
            onPressed: _resetForm,
            child: const Text('重新输入'),
          ),
      ],
    );
  }
}

/// 对战模式枚举
enum DuelMode {
  random,     // 随机匹配
  friend,     // 好友对决
  faceToFace, // 当面PK
} 