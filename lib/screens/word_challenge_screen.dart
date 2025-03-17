import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word.dart';
import '../models/answer_record.dart';
import '../models/challenge_word.dart';
import '../services/word_service.dart';
import '../utils/auth_utils.dart';
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
  
  /// 挑战单词列表
  late List<ChallengeWord> _challengeWords;
  
  /// 当前挑战单词
  late ChallengeWord _currentChallengeWord;
  
  /// 是否已选择答案
  bool _hasSelected = false;
  
  /// 选中的答案索引
  int? _selectedIndex;
  
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

  /// 是否正在加载
  bool _isLoading = true;
  
  /// 错误信息
  String? _error;
  
  /// 单词服务
  final _wordService = WordService();

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _checkLoginAndLoadWords();
  }
  
  /// 检查登录状态并加载单词
  Future<void> _checkLoginAndLoadWords() async {
    final loggedIn = await AuthUtils.checkLoginState(context);
    if (loggedIn) {
      _loadChallengeWords();
    }
  }
  
  /// 从API加载挑战单词列表
  Future<void> _loadChallengeWords() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      // 从API获取单词挑战列表
      final challengeWords = await _wordService.getChallengeWords(_totalWords);
      
      if (mounted) {
        setState(() {
          _challengeWords = challengeWords;
          _isLoading = false;
          _loadCurrentWord();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }
  
  /// 加载当前单词
  void _loadCurrentWord() {
    _currentChallengeWord = _challengeWords[_currentIndex];
    _questionStartTime = DateTime.now();
    
    // 重置选择状态
    setState(() {
      _hasSelected = false;
      _selectedIndex = null;
    });
  }
  
  /// 选择答案
  void _selectOption(int index) {
    if (_hasSelected) return;
    
    // 计算答题用时
    final answerDuration = DateTime.now().difference(_questionStartTime);
    
    final isCorrect = index == _currentChallengeWord.correctIndex;
    
    // 记录答题结果
    _answerRecords.add(
      AnswerRecord(
        word: _currentChallengeWord.word,
        userAnswer: _currentChallengeWord.options[index].text,
        correctAnswer: _currentChallengeWord.correctOption.text,
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
    
    // 只有答错才上报答题记录到后端
    if (!isCorrect) {
      _wordService.uploadAnswerRecord(
        wordId: _currentChallengeWord.id,
        myAnswer: index,
        answer: _currentChallengeWord.correctIndex,
        type: 1,
        // bookId可以根据需要设置或传null
      );
    }
    
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
    
    // 只上传错误的答题记录到后端
    final wrongRecords = _answerRecords.where((record) => !record.isCorrect).toList();
    _wordService.uploadChallengeResult(wrongRecords, totalDuration);
    
    // 导航到结果页面
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeResultScreen(
          answerRecords: _answerRecords, // 结果页面仍然显示所有记录
          totalDuration: totalDuration,
          totalWords: _answerRecords.length,
        ),
      ),
    );
  }
  
  /// 播放发音
  Future<void> _playPronunciation() async {
    try {
      // 使用单词的音频URL
      final pronunciationUrl = _currentChallengeWord.audioUrl;
      
      // 这里应该调用播放音频的代码
      // 例如: await audioPlayer.play(pronunciationUrl);
      
      // 这里只是显示演示信息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('播放发音: $pronunciationUrl')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('播放发音失败: $e')),
      );
    }
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
                  // 返回按钮
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          '单词挑战',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      // 添加与返回按钮对应的空白占位，保持对称
                      SizedBox(width: 36),
                    ],
                  ),
                  const SizedBox(height: 16),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? _buildErrorWidget()
                      : SingleChildScrollView(
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
                                      _currentChallengeWord.word,
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
                                          _currentChallengeWord.phoneticSymbol,
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
                                      _currentChallengeWord.options.length,
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
                      onPressed: _isLoading || _error != null ? null : _playPronunciation,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 下一个按钮
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading || _error != null
                          ? null
                          : _hasSelected
                              ? (_wrongCount >= _maxWrongCount || _currentIndex >= _totalWords - 1
                                  ? _endChallenge
                                  : _nextWord)
                              : null,
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
                        _wrongCount >= _maxWrongCount || _currentIndex >= _totalWords - 1
                            ? '查看结果'
                            : '下一个',
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
  
  /// 构建错误提示组件
  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              '加载数据失败',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? '未知错误',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadChallengeWords,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('重试'),
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
      if (index == _currentChallengeWord.correctIndex) {
        // 正确答案
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
      } else if (index == _selectedIndex && index != _currentChallengeWord.correctIndex) {
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
          border: _hasSelected && (index == _currentChallengeWord.correctIndex || index == _selectedIndex)
              ? Border.all(
                  color: index == _currentChallengeWord.correctIndex
                      ? Colors.green[300]!
                      : Colors.red[300]!,
                  width: 1,
                )
              : null,
        ),
        child: Text(
          _currentChallengeWord.options[index].text,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontWeight: _hasSelected && index == _currentChallengeWord.correctIndex
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
} 