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
    _userLibraries = MockData.getWordLibraries()
        .where((library) => library.isAdded)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.getCurrentUser();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                
                // 词库列表
                LibrarySection(
                  libraries: _userLibraries,
                  onViewAll: () {
                    // 查看全部词库
                  },
                  onLibraryTap: (library) {
                    // 跳转到词库详情页
                  },
                ),
                
                // 底部间距
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 