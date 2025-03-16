import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word.dart';
import '../utils/mock_data.dart';
import '../widgets/progress_bar.dart';
import '../widgets/word_card.dart';
import 'word_detail_screen.dart';

/// 学习页面
class LearningScreen extends StatefulWidget {
  /// 构造函数
  const LearningScreen({Key? key}) : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  /// 单词列表
  late List<Word> _words;
  
  /// 当前单词索引
  int _currentIndex = 0;
  
  /// 是否显示释义
  bool _showDefinition = false;
  
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

  /// 切换显示/隐藏释义
  void _toggleDefinition() {
    setState(() {
      _showDefinition = !_showDefinition;
    });
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

  /// 标记为"认识"
  void _markAsKnown() {
    if (_currentIndex < _totalWords - 1) {
      setState(() {
        _currentIndex++;
        _showDefinition = false;
        _isFavorite = false;
        
        // 打印日志，帮助调试
        print('单词已标记为认识，当前索引: $_currentIndex，总单词数: $_totalWords');
      });
    } else {
      // 学习完成，返回上一页
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('恭喜！今日学习任务已完成'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// 标记为"不认识"
  void _markAsUnknown() {
    if (_currentIndex < _totalWords - 1) {
      setState(() {
        _currentIndex++;
        _showDefinition = false;
        _isFavorite = false;
        
        // 打印日志，帮助调试
        print('单词已标记为不认识，当前索引: $_currentIndex，总单词数: $_totalWords');
      });
    } else {
      // 学习完成，返回上一页
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('恭喜！今日学习任务已完成'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// 计算当前学习进度（0.0 - 1.0）
  double _calculateProgress() {
    // 确保进度值在0.0到1.0之间
    return (_currentIndex + 1) / _totalWords;
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = _words[_currentIndex];
    final progress = _calculateProgress();
    
    // 打印进度信息，帮助调试
    print('当前进度: $progress, 索引: $_currentIndex, 总数: $_totalWords');
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildAppBar(),
            
            // 进度条 - 使用LinearProgressIndicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            
            // 单词卡片
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      WordCard(
                        word: currentWord,
                        showDefinition: _showDefinition,
                        isFavorite: _isFavorite,
                        onFavoriteToggle: _toggleFavorite,
                        onPronounce: _pronounceWord,
                        onToggleDefinition: _toggleDefinition,
                        libraryName: '大学英语四级',
                      ),
                      
                      // 当显示释义时，添加"查看更多"按钮
                      if (_showDefinition)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WordDetailScreen(word: currentWord),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryColor,
                              elevation: 0,
                              side: BorderSide(color: AppTheme.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '查看更多详情',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 16),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // 底部操作按钮
            _buildBottomActions(),
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
                '学习单词',
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

  /// 构建底部操作按钮
  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // "不认识"按钮
          Expanded(
            child: OutlinedButton(
              onPressed: _markAsUnknown,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Color(0xFFFFE4E6), width: 1),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.close, size: 20),
                  SizedBox(width: 8),
                  Text('不认识'),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // "认识"按钮
          Expanded(
            child: OutlinedButton(
              onPressed: _markAsKnown,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Color(0xFFDCFCE7), width: 1),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check, size: 20),
                  SizedBox(width: 8),
                  Text('认识'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 