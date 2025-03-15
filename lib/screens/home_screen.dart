import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word_library.dart';
import '../utils/mock_data.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/duel_entry_card.dart';
import '../widgets/library_section.dart';
import '../widgets/quick_actions_panel.dart';
import '../widgets/today_progress_section.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/welcome_section.dart';
import 'learning_screen.dart';
import 'review_screen.dart';
import 'duel_matching_screen.dart';
import 'library_selection_screen.dart';

/// 首页/仪表盘页面
class HomeScreen extends StatefulWidget {
  /// 构造函数
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// 用户的词库列表
  late List<WordLibrary> _userLibraries;
  
  /// 当前选中的词库
  WordLibrary? _currentLibrary;
  
  /// 今日进度百分比
  final double _todayProgress = 0.75;
  
  /// 已学单词数
  final int _learnedWords = 15;
  
  /// 待学单词数
  final int _wordsToLearn = 5;
  
  /// 待复习单词数
  final int _wordsToReview = 10;

  @override
  void initState() {
    super.initState();
    _loadLibraries();
  }
  
  /// 加载词库
  void _loadLibraries() {
    _userLibraries = MockData.getWordLibraries();
    
    // 获取当前选中的词库（已添加的第一个）
    if (_userLibraries.any((library) => library.isAdded)) {
      _currentLibrary = _userLibraries.firstWhere(
        (library) => library.isAdded,
      );
    } else if (_userLibraries.isNotEmpty) {
      _currentLibrary = _userLibraries.first;
    } else {
      _currentLibrary = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.getCurrentUser();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 顶部渐变背景
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3, // 屏幕高度的30%
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFDBEAFE), // 更好看的浅蓝色起始色
                    const Color(0xFFEFF6FF), 
                    const Color(0xFFF1F5F9).withOpacity(0.6),
                    Colors.white.withOpacity(0), // 渐变至透明
                  ],
                  stops: const [0.0, 0.5, 0.8, 1.0],
                ),
              ),
            ),
          ),
          // 主要内容
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顶部状态栏
                    TopAppBar(
                      initials: user.initials,
                      onNotificationTap: () {
                        // 处理通知点击
                      },
                      onAvatarTap: () {
                        // 处理头像点击
                      },
                    ),
                    
                    // 欢迎信息
                    WelcomeSection(name: user.name),
                    
                    // 当前词书显示
                    if (_currentLibrary != null)
                      _buildCurrentLibrary(_currentLibrary!),
                    
                    // 今日进度
                    TodayProgressSection(
                      progress: _todayProgress,
                      learnedWords: _learnedWords,
                      wordsToLearn: _wordsToLearn,
                      wordsToReview: _wordsToReview,
                    ),
                    
                    // 快捷操作
                    QuickActionsPanel(
                      onContinueLearning: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LearningScreen(),
                          ),
                        );
                      },
                      onReviewWords: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReviewScreen(),
                          ),
                        );
                      },
                    ),
                    
                    // 双人PK入口
                    DuelEntryCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DuelMatchingScreen(),
                          ),
                        );
                      },
                    ),
                    
                    // 词库部分
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '我的词库',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimaryColor,
                                ),
                              ),
                              Row(
                                children: [
                                  // 选择词书按钮
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const LibrarySelectionScreen(),
                                        ),
                                      ).then((_) {
                                        // 刷新词库列表
                                        setState(() {
                                          _loadLibraries();
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.menu_book,
                                      size: 16,
                                      color: AppTheme.primaryColor,
                                    ),
                                    label: const Text(
                                      '选择词书',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () {
                                      // 处理查看全部点击
                                    },
                                    child: const Text(
                                      '查看全部',
                                      style: TextStyle(
                                        color: AppTheme.textSecondaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // 词库列表
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _userLibraries.length > 5 ? 5 : _userLibraries.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final library = _userLibraries[index];
                            return _buildLibraryItem(library);
                          },
                        ),
                      ],
                    ),
                    
                    // 底部间距
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建当前词书卡片
  Widget _buildCurrentLibrary(WordLibrary library) {
    // 将十六进制颜色字符串转换为Color对象
    final Color backgroundColor = Color(int.parse(library.backgroundColor.substring(1), radix: 16) + 0xFF000000);
    final Color textColor = Color(int.parse(library.textColor.substring(1), radix: 16) + 0xFF000000);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: backgroundColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // 词书图标
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.book,
              color: textColor,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 词书信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      library.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '当前',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${(library.progress * library.wordCount / 100).toInt()}/${library.wordCount} 词 · 已学习 ${library.progress}%',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // 切换按钮
          TextButton(
            onPressed: () {
              // 点击跳转到词书选择页面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LibrarySelectionScreen(),
                ),
              ).then((_) {
                // 刷新词库列表
                setState(() {
                  _loadLibraries();
                });
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(60, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '切换',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建学习统计卡片
  Widget _buildStatisticsCard() {
    return Transform.translate(
      offset: const Offset(0, -20), // 向上偏移20像素
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '学习统计',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatisticsItem('今日单词', '28'),
                _buildStatisticsItem('连续打卡', '3'),
                _buildStatisticsItem('总计词量', '1,286'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatisticsItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
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
    );
  }

  /// 构建词库项
  Widget _buildLibraryItem(WordLibrary library) {
    // 将十六进制颜色字符串转换为Color对象
    final Color backgroundColor = Color(int.parse(library.backgroundColor.substring(1), radix: 16) + 0xFF000000);
    final Color textColor = Color(int.parse(library.textColor.substring(1), radix: 16) + 0xFF000000);
    final isCurrentLibrary = _currentLibrary?.id == library.id;
    
    return Container(
      decoration: BoxDecoration(
        color: isCurrentLibrary ? backgroundColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentLibrary ? backgroundColor.withOpacity(0.3) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // 处理词库点击
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 词库图标
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.book,
                  color: textColor,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 词库信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          library.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        if (isCurrentLibrary)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '当前',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(library.progress * library.wordCount / 100).toInt()}/${library.wordCount} 词 · ${library.difficulty}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 进度条
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${library.progress}%',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 48,
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: library.progress / 100,
                        backgroundColor: const Color(0xFFE5E7EB),
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 