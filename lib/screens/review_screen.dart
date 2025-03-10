import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word.dart';
import '../utils/mock_data.dart';
import '../widgets/progress_bar.dart';
import '../widgets/word_card.dart';

/// 复习页面
class ReviewScreen extends StatefulWidget {
  /// 构造函数
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  /// 单词列表
  late List<Word> _words;
  
  /// 当前单词索引
  int _currentIndex = 0;
  
  /// 是否已收藏当前单词
  bool _isFavorite = false;
  
  /// 总单词数
  late int _totalWords;

  @override
  void initState() {
    super.initState();
    _words = MockData.getWords();
    _totalWords = _words.length;
  }

  /// 切换收藏状态
  void _toggleFavorite(bool value) {
    setState(() {
      _isFavorite = value;
    });
  }

  /// 发音
  void _pronounceWord() {
    // 实际应用中，这里应该调用文本转语音API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('播放发音...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// 评估记忆程度
  void _evaluateMemory(int level) {
    if (_currentIndex < _totalWords - 1) {
      setState(() {
        _currentIndex++;
        _isFavorite = false;
      });
    } else {
      // 复习完成，返回上一页
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('恭喜！今日复习任务已完成'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = _words[_currentIndex];
    final progress = (_currentIndex + 1) / _totalWords;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildAppBar(),
            
            // 进度条
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ProgressBar(
                progress: progress,
                height: 8,
                borderRadius: 4,
              ),
            ),
            
            // 单词卡片
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 单词卡片
                      WordCard(
                        word: currentWord,
                        showDefinition: true, // 复习模式下始终显示释义
                        isFavorite: _isFavorite,
                        onFavoriteToggle: _toggleFavorite,
                        onPronounce: _pronounceWord,
                        libraryName: '大学英语四级',
                      ),
                      
                      // 记忆评估
                      _buildMemoryEvaluation(),
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
                '单词复习',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          // 进度和更多按钮
          Row(
            children: [
              Text(
                '${_currentIndex + 1}/$_totalWords',
                style: const TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  // 显示更多选项
                },
                child: const Icon(
                  Icons.more_horiz,
                  color: AppTheme.textSecondaryColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建记忆评估部分
  Widget _buildMemoryEvaluation() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '记忆评估',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildEvaluationButton(
                label: '忘记',
                color: Colors.red,
                bgColor: const Color(0xFFFEE2E2),
                level: 1,
              ),
              const SizedBox(width: 8),
              _buildEvaluationButton(
                label: '困难',
                color: Colors.orange,
                bgColor: const Color(0xFFFEF3C7),
                level: 2,
              ),
              const SizedBox(width: 8),
              _buildEvaluationButton(
                label: '一般',
                color: Colors.green,
                bgColor: const Color(0xFFDCFCE7),
                level: 3,
              ),
              const SizedBox(width: 8),
              _buildEvaluationButton(
                label: '简单',
                color: Colors.blue,
                bgColor: const Color(0xFFDBEAFE),
                level: 4,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建评估按钮
  Widget _buildEvaluationButton({
    required String label,
    required Color color,
    required Color bgColor,
    required int level,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _evaluateMemory(level),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
} 