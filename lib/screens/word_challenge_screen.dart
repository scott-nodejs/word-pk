import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word.dart';
import '../models/answer_record.dart';
import '../utils/mock_data.dart';
import 'challenge_result_screen.dart';

/// 单词挑战页面
class WordChallengeScreen extends StatefulWidget {
  /// 构造函数
  const WordChallengeScreen({Key? key}) : super(key: key);

  @override
  State<WordChallengeScreen> createState() => _WordChallengeScreenState();
}

class _WordChallengeScreenState extends State<WordChallengeScreen> {
  /// 当前单词索引
  int _currentIndex = 0; // 从第1个开始
  
  /// 总单词数量
  final int _totalWords = 10;
  
  /// 单词列表
  late List<Word> _words;
  
  /// 当前单词
  late Word _currentWord;
  
  /// 选项列表
  late List<String> _options;
  
  /// 是否已选择答案
  bool _hasSelected = false;
  
  /// 选中的答案索引
  int? _selectedIndex;
  
  /// 正确答案索引
  late int _correctIndex;
  
  /// 错误次数
  int _wrongCount = 0;
  
  /// 最大错误次数
  final int _maxWrongCount = 3;
  
  /// 答题记录列表，用于结果页面
  final List<AnswerRecord> _answerRecords = [];
  
  /// 开始答题时间
  late DateTime _startTime;
  
  /// 当前题答题开始时间
  late DateTime _questionStartTime;

  @override
  void initState() {
    super.initState();
    // 获取单词列表
    _words = MockData.getWordsForChallenge(_totalWords);
    _startTime = DateTime.now();
    _loadCurrentWord();
  }
  
  /// 加载当前单词和选项
  void _loadCurrentWord() {
    _currentWord = _words[_currentIndex];
    _questionStartTime = DateTime.now();
    
    // 获取所有可能的含义
    _options = [];
    
    // 确保至少有一个正确答案
    if (_currentWord.definitions.isNotEmpty) {
      String correctMeaning = _currentWord.definitions.first.meaning;
      _options.add(correctMeaning);
      
      // 添加单词的其他含义（如果有）
      for (int i = 1; i < _currentWord.definitions.length && _options.length < 4; i++) {
        String meaning = _currentWord.definitions[i].meaning;
        if (!_options.contains(meaning)) {
          _options.add(meaning);
        }
      }
    } else {
      // 如果没有定义，添加一个默认选项
      _options.add("无可用定义");
    }
    
    // 如果选项不足4个，添加一些常见错误选项
    final wrongMeanings = MockData.getRandomWrongMeanings(10); // 获取多个错误选项
    int wrongIndex = 0;
    
    while (_options.length < 4 && wrongIndex < wrongMeanings.length) {
      final randomMeaning = wrongMeanings[wrongIndex++];
      if (!_options.contains(randomMeaning)) {
        _options.add(randomMeaning);
      }
    }
    
    // 打乱选项顺序
    _options.shuffle();
    
    // 找出正确答案的索引
    if (_currentWord.definitions.isNotEmpty) {
      _correctIndex = _options.indexOf(_currentWord.definitions.first.meaning);
      // 如果找不到正确答案（这不应该发生，但以防万一）
      if (_correctIndex == -1) {
        _correctIndex = 0; // 默认使用第一个选项
        _options[0] = _currentWord.definitions.first.meaning; // 强制第一个选项为正确答案
      }
    } else {
      _correctIndex = 0; // 默认第一个为正确答案
    }
    
    // 重置选择状态
    _hasSelected = false;
    _selectedIndex = null;
  }
  
  /// 选择答案
  void _selectOption(int index) {
    if (_hasSelected) return;
    
    // 计算答题用时
    final answerDuration = DateTime.now().difference(_questionStartTime);
    
    final isCorrect = index == _correctIndex;
    
    // 记录答题结果
    _answerRecords.add(
      AnswerRecord(
        word: _currentWord.text,
        userAnswer: _options[index],
        correctAnswer: _options[_correctIndex],
        isCorrect: isCorrect,
        duration: answerDuration,
      ),
    );
    
    setState(() {
      _hasSelected = true;
      _selectedIndex = index;
      
      // 如果答案错误，增加错误计数
      if (!isCorrect) {
        _wrongCount++;
      }
    });
    
    // 检查游戏是否应该结束
    bool shouldEnd = _wrongCount >= _maxWrongCount || 
                     _currentIndex >= _totalWords - 1;
    
    // 延迟后进入下一题或结束游戏
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (shouldEnd) {
          _endChallenge();
        } else {
          _nextWord();
        }
      }
    });
  }
  
  /// 下一个单词
  void _nextWord() {
    setState(() {
      _currentIndex++;
      _loadCurrentWord();
    });
  }
  
  /// 结束挑战并导航到结果页面
  void _endChallenge() {
    // 计算总用时
    final totalDuration = DateTime.now().difference(_startTime);
    
    // 导航到结果页面
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeResultScreen(
          answerRecords: _answerRecords,
          totalDuration: totalDuration,
          totalWords: _answerRecords.length,
        ),
      ),
    );
  }
  
  /// 播放发音
  void _playPronunciation() {
    // TODO: 实现发音播放功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('播放发音...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 计算进度百分比
    final progress = (_currentIndex + 1) / _totalWords;
    final progressPercent = (progress * 100).toInt();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部进度条
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                children: [
                  // 进度文本
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '第 ${_currentIndex + 1}/$_totalWords 个',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      Text(
                        '$progressPercent%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 进度条
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            
            // 单词卡片
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // 单词卡片
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey[200]!,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // 单词和发音
                          Text(
                            _currentWord.text,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentWord.pronunciation,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.volume_up_outlined),
                                onPressed: _playPronunciation,
                                color: Colors.grey[500],
                                iconSize: 20,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // 选项列表
                          ...List.generate(
                            _options.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildOptionButton(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 底部操作栏
            Container(
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
              child: Row(
                children: [
                  // 发音按钮
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.volume_up_outlined),
                      onPressed: _playPronunciation,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 下一个按钮
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _hasSelected ? (
                        _wrongCount >= _maxWrongCount || _currentIndex >= _totalWords - 1 ? 
                        _endChallenge : _nextWord
                      ) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.6),
                      ),
                      child: Text(
                        _wrongCount >= _maxWrongCount || _currentIndex >= _totalWords - 1 ? 
                        '查看结果' : '下一个',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建选项按钮
  Widget _buildOptionButton(int index) {
    // 确定按钮颜色
    Color backgroundColor = Colors.grey[50]!;
    Color textColor = const Color(0xFF1F2937);
    
    if (_hasSelected) {
      if (index == _correctIndex) {
        // 正确答案
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
      } else if (index == _selectedIndex && index != _correctIndex) {
        // 选择的错误答案
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
      }
    }
    
    return InkWell(
      onTap: () => _selectOption(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: _hasSelected && (index == _correctIndex || index == _selectedIndex)
              ? Border.all(
                  color: index == _correctIndex
                      ? Colors.green[300]!
                      : Colors.red[300]!,
                  width: 1,
                )
              : null,
        ),
        child: Text(
          _options[index],
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontWeight: _hasSelected && index == _correctIndex
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
} 