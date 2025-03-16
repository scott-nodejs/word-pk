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
import 'study_statistics_screen.dart';
import '../constants/app_constants.dart';
import 'main_screen.dart';

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
  final int _wordsToReview = 32;

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

  /// 构建顶部导航栏
  Widget _buildTopBar(user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 头像和问候语
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    user.initials,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F46E5),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '你好，',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // 功能按钮
          Row(
            children: [
              _buildIconButton(Icons.notifications_none_outlined, () {
                    // 处理通知点击
              }),
              const SizedBox(width: 8),
              _buildIconButton(Icons.settings_outlined, () {
                // 处理设置点击
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建图标按钮
  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: const Color(0xFF6B7280),
          size: 20,
        ),
      ),
    );
  }

  /// 构建当前词书卡片
  Widget _buildCurrentLibrary(WordLibrary library) {
    // 将十六进制颜色字符串转换为Color对象
    final Color backgroundColor = Color(int.parse(library.backgroundColor.substring(1), radix: 16) + 0xFF000000);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Row(
          children: [
            // 词书图标
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.book_outlined,
                color: Color(0xFF4F46E5),
                size: 24,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // 词书信息和进度条
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    library.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // 进度条
                      SizedBox(
                        width: 96,
                        height: 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: library.progress / 100,
                            backgroundColor: const Color(0xFFF3F4F6),
                            valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 进度文字
                      Text(
                        '已学习 ${library.progress}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 更换按钮
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LibrarySelectionScreen(),
                  ),
                ).then((_) {
                  setState(() {
                    _loadLibraries();
                  });
                });
              },
              child: Row(
                children: [
                  Text(
                    '更换',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: backgroundColor,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: backgroundColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建今日进度
  Widget _buildTodayProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '今日进度',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // 已学习
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.book_outlined,
                              color: Color(0xFF4F46E5),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '已学习',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_learnedWords}个',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '今日目标: ${_learnedWords + _wordsToLearn}个',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // 待复习
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF9333EA),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '待复习',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_wordsToReview}个',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '记忆良好: 75%',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建快速操作
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '快速操作',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 开始学习
              _buildQuickActionItem(
                icon: Icons.refresh,
                iconColor: const Color(0xFF3B82F6),
                backgroundColor: const Color(0xFFDBEAFE),
                label: '开始学习',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LearningScreen(),
                    ),
                  );
                },
              ),
              
              // 复习单词
              _buildQuickActionItem(
                icon: Icons.visibility_outlined,
                iconColor: const Color(0xFF9333EA),
                backgroundColor: const Color(0xFFF3E8FF),
                label: '复习单词',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReviewScreen(),
                    ),
                  );
                },
              ),
              
              // 学习统计
              _buildQuickActionItem(
                icon: Icons.bar_chart,
                iconColor: const Color(0xFF10B981),
                backgroundColor: const Color(0xFFD1FAE5),
                label: '学习统计',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudyStatisticsScreen(),
                    ),
                  );
                },
              ),
              
              // 错题集
              _buildQuickActionItem(
                icon: Icons.bookmark_border,
                iconColor: const Color(0xFFEF4444),
                backgroundColor: const Color(0xFFFEE2E2),
                label: '错题集',
                onTap: () {
                  // 导航到错题集页面
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建快速操作项
  Widget _buildQuickActionItem({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建对战专区
  Widget _buildDuelSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '对战专区',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // 选择词书
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF9C3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Color(0xFFCA8A04),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '选择词书',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const Text(
                                '更换学习词库',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LibrarySelectionScreen(),
                            ),
                          ).then((_) {
                            setState(() {
                              _loadLibraries();
                            });
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF9C3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '立即更换',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFCA8A04),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // 对决历史
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E7FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.content_copy_outlined,
                              color: Color(0xFF4F46E5),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '对决历史',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const Text(
                                '查看历史战绩',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          // 导航到对决历史页面
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '查看记录',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建对战入口卡片
  Widget _buildDuelEntryCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '单词对决',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '胜率 65%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '挑战其他用户，在对战中提升词汇量',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFE0E7FF),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // 开始对战按钮
                GestureDetector(
                  onTap: () {
                    // 使用MainScreen提供的静态方法来切换到对战页面
                    MainScreen.navigateToTab(context, AppConstants.learningTabIndex);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      '开始对战',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // 排行榜按钮
                GestureDetector(
                  onTap: () {
                    // 导航到排行榜页面
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '排行榜',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建我的词库
  Widget _buildMyLibraries() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '我的词库',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // 查看全部词库
                },
                child: const Text(
                  '查看全部',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _userLibraries.length > 2 ? 2 : _userLibraries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final library = _userLibraries[index];
              return _buildLibraryItem(library);
            },
          ),
        ],
      ),
    );
  }

  /// 构建词库项
  Widget _buildLibraryItem(WordLibrary library) {
    // 将十六进制颜色字符串转换为Color对象
    final Color backgroundColor = Color(int.parse(library.backgroundColor.substring(1), radix: 16) + 0xFF000000);
    final Color textColor = Color(int.parse(library.textColor.substring(1), radix: 16) + 0xFF000000);
    final isCurrentLibrary = _currentLibrary?.id == library.id;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 词库图标和名称
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.book_outlined,
                      color: textColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        library.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        '${library.wordCount}词',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // 进度百分比
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${library.progress}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const Text(
                    '已学习',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 进度条
          SizedBox(
            width: double.infinity,
            height: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: library.progress / 100,
                backgroundColor: const Color(0xFFF3F4F6),
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.getCurrentUser();
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // 顶部渐变背景
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.3, // 顶部30%区域
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE0F2FE), // 浅蓝色开始
                    Color(0xFFDCEFFF), 
                    Color(0xFFECF5FF),
                    Color(0xFFF9FAFB), // 与页面背景色融合
                  ],
                ),
              ),
            ),
          ),
          
          // 主内容
          Column(
            children: [
              // 顶部空白区域
              const SizedBox(height: 32),
              
              // 主内容区域
              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 顶部导航栏
                        _buildTopBar(user),
                        
                        // 当前选中词书
                        if (_currentLibrary != null)
                          _buildCurrentLibrary(_currentLibrary!),
                        
                        // 今日进度
                        _buildTodayProgress(),
                        
                        // 快速操作
                        _buildQuickActions(),
                        
                        // 对战专区
                        _buildDuelSection(),
                        
                        // 对战入口卡片
                        _buildDuelEntryCard(),
                        
                        // 我的词库
                        _buildMyLibraries(),
                        
                        // 底部间距（为底部导航栏预留空间）
                        const SizedBox(height: 80),
                      ],
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
} 