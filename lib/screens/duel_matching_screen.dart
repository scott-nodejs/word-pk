import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word_library.dart';
import '../utils/mock_data.dart';
import '../widgets/gradient_background.dart';
import '../widgets/library_card.dart';
import 'duel_battle_screen.dart';

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
      Navigator.pop(context); // 关闭匹配对话框
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
    });
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
          Row(
            children: [
              // 随机匹配
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // 选择随机匹配模式
                  },
                  child: GradientBackground(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: 12,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 标题和图标
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '随机匹配',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // 描述
                          Text(
                            '与水平相近的用户匹配',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // 按钮
                          ElevatedButton(
                            onPressed: _startMatching,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF6366F1),
                              minimumSize: const Size(0, 28),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: const Text('开始匹配'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 好友对决
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // 选择好友对决模式
                  },
                  child: GradientBackground(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA855F7), Color(0xFF9333EA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: 12,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 标题和图标
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '好友对决',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // 描述
                          Text(
                            '邀请好友一起对决',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // 按钮
                          ElevatedButton(
                            onPressed: () {
                              // 邀请好友
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFA855F7),
                              minimumSize: const Size(0, 28),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: const Text('邀请好友'),
                          ),
                        ],
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
          onPressed: _startMatching,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            '开始匹配',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建历史对决部分
  Widget _buildDuelHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题和查看全部按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '历史对决',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () {
                // 查看全部历史对决
              },
              child: const Text(
                '查看全部',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        
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
}

/// 匹配中对话框
class _MatchingDialog extends StatelessWidget {
  const _MatchingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          const Text(
            '正在匹配对手...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '请稍候片刻',
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