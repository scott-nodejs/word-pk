import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word_library.dart';
import '../models/user.dart';
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
  
  /// 是否自动发音
  bool _autoPronunciation = true;
  
  /// 对战历史
  final _duelHistory = MockData.getDuelHistory();
  
  /// 当前选择的对战模式
  DuelMode _selectedMode = DuelMode.random;

  /// 热门对战者列表（不再需要，已使用硬编码数据）
  // final _hotDuelers = [
  //   {
  //     'name': '张三',
  //     'initials': 'ZS',
  //     'color': Colors.blue,
  //     'online': true,
  //     'lastSeen': '在线',
  //   },
  //   {
  //     'name': '李四',
  //     'initials': 'LS',
  //     'color': Colors.purple,
  //     'online': true,
  //     'lastSeen': '在线',
  //   },
  //   {
  //     'name': '王五',
  //     'initials': 'WW',
  //     'color': Colors.orange,
  //     'online': false,
  //     'lastSeen': '5分钟前',
  //   },
  //   {
  //     'name': '赵六',
  //     'initials': 'ZL',
  //     'color': Colors.green,
  //     'online': false,
  //     'lastSeen': '1小时前',
  //   },
  //   {
  //     'name': '钱七',
  //     'initials': 'QQ',
  //     'color': Colors.red,
  //     'online': false,
  //     'lastSeen': '2小时前',
  //   },
  // ];

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
    
    // 模拟匹配过程，0.8秒后显示匹配成功界面（加快匹配速度）
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return; // 如果组件已销毁，则不执行导航操作
      
      // 获取对话框的context，用于关闭对话框
      final navigatorContext = Navigator.of(context).context;
      if (navigatorContext.mounted) {
        Navigator.pop(navigatorContext); // 关闭匹配对话框
        
        // 显示匹配成功的对战房间界面
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _DuelRoomDialog(
            opponent: MockData.getDuelHistory().first.player2, // 模拟对手数据
            onStartDuel: () {
              // 关闭对战房间对话框
              Navigator.pop(context);
              
              // 跳转到对战页面
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
            },
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

  /// 开始好友PK
  void _startFriendDuel() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _FriendDuelDialog(
        onShareToWechat: () {
          // 模拟微信分享，在实际应用中这里应该调用微信分享SDK
          print('分享给微信好友');
          
          // 获取对话框的context，不要关闭对话框，而是在对话框内显示倒计时
          final dialogContext = Navigator.of(context).context;
          
          // 模拟30秒后微信好友接受邀请
          Future.delayed(const Duration(seconds: 5), () {
            if (!mounted) return;
            
            // 关闭对话框
            if (dialogContext.mounted) {
              Navigator.pop(dialogContext);
              
              // 显示匹配成功的对话框
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => _DuelRoomDialog(
                  opponent: MockData.getDuelHistory().first.player2, // 模拟对手数据
                  onStartDuel: () {
                    // 关闭对战房间对话框
                    Navigator.pop(context);
                    
                    // 跳转到对战页面
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
                  },
                ),
              );
            }
          });
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
      body: SafeArea(
        bottom: false, // 不对底部使用安全区域，因为有导航栏
        child: Stack(
          children: [
            // 顶部渐变背景
            // 顶部渐变背景
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3, // 顶部30%区域
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
            
            // 主要内容
            Column(
              children: [
                // 顶部空白区域
                const SizedBox(height: 24),
                
            // 顶部导航栏
                //_buildAppBar(),
            
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // 用户状态
                        _buildUserStatus(),
                        
                      // 对决模式选择
                      _buildDuelModeSection(),
                      
                      // 对决设置
                      _buildDuelSettings(),
                      
                      // 开始按钮
                        //_buildStartButton(),
                        
                        // 底部快捷操作
                        _buildBottomActions(),
                        
                        // 对战历史和排行榜
                        //_buildHistoryAndRanking(),
                        
                        // 热门对战者
                        //_buildHotDuelers(),
                      
                      // 底部间距
                        const SizedBox(height: 120),
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

  /// 构建顶部导航栏
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 标题
          const Text(
            '单词对决',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937), // text-gray-800
            ),
          ),
          
          // 帮助按钮 - 使用圆形白色背景
          Container(
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
            child: const Center(
              child: Icon(
                Icons.info_outline,
                color: Color(0xFF6B7280), // text-gray-500
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建用户状态
  Widget _buildUserStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
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
          border: Border.all(color: const Color(0xFFF3F4F6)), // border-gray-100
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 用户头像和信息
          Row(
            children: [
                // 头像
                Container(
                  width: 48, 
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E7FF), // bg-indigo-100
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'JD',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5), // text-indigo-600
                      ),
                    ),
                  ),
                ),
                
              const SizedBox(width: 12),
                
                // 用户名和等级
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              const Text(
                      'John Doe',
                style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937), // text-gray-800
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // 等级
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFBBF24), // text-yellow-400
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Lv.8',
                              style: TextStyle(
                                color: Color(0xFF6B7280), // text-gray-500
                                fontSize: 12,
                ),
              ),
            ],
          ),
          
                        const SizedBox(width: 12),
                        
                        // 积分
                        Row(
                          children: [
                            const Icon(
                              Icons.bolt,
                              color: Color(0xFFF87171), // text-red-400
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '1250分',
                              style: TextStyle(
                                color: Color(0xFF6B7280), // text-gray-500
                                fontSize: 12,
            ),
          ),
        ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            // 胜率显示
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF)], // from-indigo-50 to-purple-50
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '65%',
                    style: TextStyle(
                      color: Color(0xFF4F46E5), // text-indigo-600
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    '胜率',
                    style: TextStyle(
                      color: Color(0xFF6B7280), // text-gray-500
                      fontSize: 12,
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

  /// 构建对决模式选择部分
  Widget _buildDuelModeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择对战模式',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937), // text-gray-800
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          
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
                    _startMatching(); // 直接开始随机匹配
                  },
                  child: Container(
                    height: 112, // h-28
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _selectedMode == DuelMode.random
                            ? const [Color(0xFF3B82F6), Color(0xFF4F46E5)]
                            : [const Color(0xFF3B82F6).withOpacity(0.85), const Color(0xFF4F46E5).withOpacity(0.85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F46E5).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 图标
                              Container(
                            width: 48,
                            height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(
                              Icons.autorenew,
                                  color: Colors.white,
                              size: 24,
                                ),
                              ),
                          const SizedBox(height: 8),
                          const Text(
                            '随机对战',
                            style: TextStyle(
                              color: Colors.white,
                                fontWeight: FontWeight.w500,
                              fontSize: 14,
                              ),
                          ),
                        ],
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
                    _startFriendDuel(); // 开始好友PK流程
                  },
                  child: Container(
                    height: 112, // h-28
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _selectedMode == DuelMode.friend
                            ? const [Color(0xFFA855F7), Color(0xFFDB2777)]
                            : [const Color(0xFFA855F7).withOpacity(0.85), const Color(0xFFDB2777).withOpacity(0.85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA855F7).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 图标
                              Container(
                            width: 48,
                            height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(
                                  Icons.people_outline,
                                  color: Colors.white,
                              size: 24,
                                ),
                              ),
                          const SizedBox(height: 8),
                          const Text(
                            '好友对战',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
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
                    _startFaceToFaceDuel(); // 直接开始当面PK匹配
                  },
                  child: Container(
                    height: 112, // h-28
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _selectedMode == DuelMode.faceToFace
                            ? const [Color(0xFFF59E0B), Color(0xFFEF4444)]
                            : [const Color(0xFFF59E0B).withOpacity(0.85), const Color(0xFFEF4444).withOpacity(0.85)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 图标
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.group,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '当面PK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
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
                        Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedLibrary?.name ?? '大学英语四级',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimaryColor,
                                fontSize: 16,
                              ),
                                overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_selectedLibrary?.wordCount ?? 2500}词 | 难度: ${_selectedLibrary?.difficulty ?? '中等'}',
                              style: const TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 12,
                              ),
                                overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
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
          border: Border.all(color: const Color(0xFFF3F4F6)), // border-gray-100
        ),
        padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // 标题
            Row(
              children: [
                const Icon(
                  Icons.settings,
                  color: Color(0xFF4F46E5), // text-indigo-500
                  size: 20,
                ),
                const SizedBox(width: 8),
          const Text(
                  '对战设置',
            style: TextStyle(
              fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937), // text-gray-800
                  ),
                ),
              ],
          ),
          const SizedBox(height: 16),
            
            // 词库选择
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '选择词库',
                  style: TextStyle(
                    color: Color(0xFF6B7280), // text-gray-600
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showLibrarySelectionDialog();
                  },
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedLibrary?.name ?? '四级核心词汇',
                            style: const TextStyle(
                              color: Color(0xFF4F46E5), // text-indigo-600
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF4F46E5), // text-indigo-600
                          size: 20,
          ),
        ],
      ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Color(0xFFF3F4F6)), // border-gray-100
            ),
            
            // 单词数量
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
                const Text(
                  '单词数量',
                  style: TextStyle(
                    color: Color(0xFF6B7280), // text-gray-600
                    fontSize: 14,
                  ),
                ),
                Row(
            children: [
                    // 减少按钮
                    GestureDetector(
                      onTap: () => _adjustWordCount(-5),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6), // bg-gray-100
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Color(0xFF6B7280), // text-gray-500
                          size: 16,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8), // 增加间距
                    
                    // 数值
                    Container(
                      width: 70,
                      child: Text(
                        '$_wordCount题',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937), // text-gray-800
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(width: 8), // 增加间距
                    
                    // 增加按钮
                    GestureDetector(
                      onTap: () => _adjustWordCount(5),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF), // bg-indigo-100
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF4F46E5), // text-indigo-500
                          size: 16,
                        ),
                ),
              ),
            ],
          ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Color(0xFFF3F4F6)), // border-gray-100
            ),
            
            // 时间限制
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '时间限制',
                  style: TextStyle(
                    color: Color(0xFF6B7280), // text-gray-600
                    fontSize: 14,
                  ),
                ),
        Row(
          children: [
            // 减少按钮
            GestureDetector(
                      onTap: () => _adjustTimeLimit(-5),
              child: Container(
                        width: 28,
                        height: 28,
                decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6), // bg-gray-100
                          borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.remove,
                          color: Color(0xFF6B7280), // text-gray-500
                          size: 16,
                ),
              ),
            ),
                    
                    const SizedBox(width: 8), // 增加间距
            
            // 数值
                    Container(
                      width: 80,
              child: Text(
                        '$_timeLimit秒/题',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937), // text-gray-800
                          fontSize: 14,
                ),
                textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
              ),
            ),
                    
                    const SizedBox(width: 8),
            
            // 增加按钮
            GestureDetector(
                      onTap: () => _adjustTimeLimit(5),
              child: Container(
                        width: 28,
                        height: 28,
                decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF), // bg-indigo-100
                          borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add,
                          color: Color(0xFF4F46E5), // text-indigo-500
                          size: 16,
                ),
              ),
            ),
          ],
        ),
      ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Color(0xFFF3F4F6)), // border-gray-100
            ),
            
            // 自动发音
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '自动发音',
                  style: TextStyle(
                    color: Color(0xFF6B7280), // text-gray-600
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 24,
                  child: Switch(
                    value: _autoPronunciation,
                    onChanged: (value) {
                      setState(() {
                        _autoPronunciation = value;
                      });
                    },
                    activeColor: const Color(0xFF4F46E5), // bg-indigo-600
                    activeTrackColor: const Color(0xFFE0E7FF), // bg-indigo-100
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建开始按钮
  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: ElevatedButton(
        onPressed: _selectedMode == DuelMode.faceToFace ? _startFaceToFaceDuel : _startMatching,
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFFA855F7)], // from-indigo-600 to-purple-600
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedMode == DuelMode.faceToFace ? '开始当面PK' : '开始对战',
                  style: const TextStyle(
                    color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建对战历史和排行榜部分
  Widget _buildHistoryAndRanking() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          // 对战历史
          Expanded(
            child: Container(
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
                border: Border.all(color: const Color(0xFFF3F4F6)), // border-gray-100
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Row(
          children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF4F46E5), // text-indigo-500
                        size: 20,
                      ),
                      const SizedBox(width: 8),
            const Text(
                        '对战历史',
              style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937), // text-gray-800
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // 历史记录
                  Column(
                    children: [
                      _buildHistoryItem(isWinner: true, opponentName: '李小明', time: '今天 14:20', score: '8:2'),
                      const SizedBox(height: 8),
                      _buildHistoryItem(isWinner: false, opponentName: '张小花', time: '今天 13:05', score: '4:6'),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 查看全部按钮
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
              onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DuelHistoryScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F4F6), // bg-gray-100
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
              child: const Text(
                '查看全部',
                style: TextStyle(
                          color: Color(0xFF6B7280), // text-gray-600
                          fontSize: 12,
                        ),
                ),
              ),
            ),
          ],
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // 排行榜
          Expanded(
            child: Container(
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
                border: Border.all(color: const Color(0xFFF3F4F6)), // border-gray-100
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Row(
                    children: [
                      const Icon(
                        Icons.bar_chart,
                        color: Color(0xFF4F46E5), // text-indigo-500
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '排行榜',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937), // text-gray-800
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // 排行榜记录
                  Column(
                    children: [
                      _buildRankingItem(rank: 1, initials: 'SK', name: 'Sarah Kim', score: '1865分'),
                      const SizedBox(height: 8),
                      _buildRankingItem(rank: 2, initials: 'MJ', name: 'Mike Johnson', score: '1720分'),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 查看全部按钮
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DuelRankingScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F4F6), // bg-gray-100
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '查看全部',
                        style: TextStyle(
                          color: Color(0xFF6B7280), // text-gray-600
                          fontSize: 12,
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
    );
  }

  /// 构建历史记录项
  Widget _buildHistoryItem({
    required bool isWinner,
    required String opponentName,
    required String time,
    required String score,
  }) {
    return Row(
                children: [
                  // 胜负标志
                  Container(
          width: 32,
          height: 32,
                    decoration: BoxDecoration(
            color: isWinner ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        isWinner ? '胜' : '负',
                        style: TextStyle(
                color: isWinner ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          fontWeight: FontWeight.bold,
                fontSize: 12,
                        ),
                      ),
                    ),
                  ),
        const SizedBox(width: 8),
                  
                  // 对战信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                'vs $opponentName',
                          style: const TextStyle(
                  color: Color(0xFF1F2937), // text-gray-800
                  fontSize: 13,
                          ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                        ),
                        Text(
                time,
                          style: const TextStyle(
                  color: Color(0xFF6B7280), // text-gray-500
                  fontSize: 11,
                          ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  
        // 分数
                  Text(
          score,
          style: const TextStyle(
            color: Color(0xFF1F2937), // text-gray-800
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 构建排行榜项
  Widget _buildRankingItem({
    required int rank,
    required String initials,
    required String name,
    required String score,
  }) {
    // 不同排名对应不同颜色
    Color bgColor;
    Color textColor;
    
    if (rank == 1) {
      bgColor = const Color(0xFFFEF3C7); // bg-yellow-100
      textColor = const Color(0xFFD97706); // text-yellow-600
    } else {
      bgColor = const Color(0xFFF3F4F6); // bg-gray-100
      textColor = const Color(0xFF6B7280); // text-gray-500
    }
    
    return Row(
      children: [
        // 排名
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              rank.toString(),
                    style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        
        // 用户头像
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E7FF), // bg-indigo-100
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: Color(0xFF4F46E5), // text-indigo-600
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        
        // 用户名和分数
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1F2937), // text-gray-800
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                score,
                style: const TextStyle(
                  color: Color(0xFF1F2937), // text-gray-800
                  fontSize: 12,
                      fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建热门对战者
  Widget _buildHotDuelers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '热门对战者',
            style: TextStyle(
                      fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937), // text-gray-800
            ),
          ),
          const SizedBox(height: 8),
          Container(
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
              border: Border.all(color: const Color(0xFFF3F4F6)), // border-gray-100
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDuelerItem(
                    initials: 'EW',
                    name: 'Emma W.',
                    isOnline: true,
                    status: '在线',
                    color: Colors.purple,
                  ),
                  const SizedBox(width: 16),
                  _buildDuelerItem(
                    initials: 'AZ',
                    name: 'Alex Z.',
                    isOnline: true,
                    status: '在线',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildDuelerItem(
                    initials: 'DC',
                    name: 'David C.',
                    isOnline: false,
                    status: '19分钟前',
                    color: Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _buildDuelerItem(
                    initials: 'TW',
                    name: 'Tom W.',
                    isOnline: false,
                    status: '42分钟前',
                    color: Colors.red,
                  ),
                  const SizedBox(width: 16),
                  _buildDuelerItem(
                    initials: 'SL',
                    name: 'Sophie L.',
                    isOnline: true,
                    status: '在线',
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 16),
                  _buildDuelerItem(
                    initials: 'AL',
                    name: 'Amy L.',
                    isOnline: false,
                    status: '1小时前',
                    color: Colors.pink,
                  ),
                ],
              ),
            ),
          ),
                ],
              ),
            );
  }

  /// 构建单个对战者项
  Widget _buildDuelerItem({
    required String initials,
    required String name,
    required bool isOnline,
    required String status,
    required Color color,
  }) {
    return Column(
      children: [
        // 头像和在线状态
        SizedBox(
          width: 60,  // 稍大于头像以容纳溢出的在线状态标记
          height: 60, // 稍大于头像以容纳溢出的在线状态标记
          child: Stack(
            clipBehavior: Clip.none, // 允许子元素超出Stack边界
            fit: StackFit.expand, // 确保Stack填充父容器
            children: [
              // 头像 - 居中放置，确保有空间给在线标记
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // 在线状态标记
              if (isOnline)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981), // text-green-500
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 名称
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1F2937), // text-gray-800
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        
        // 状态
        Text(
          status,
          style: TextStyle(
            fontSize: 11,
            color: isOnline 
              ? const Color(0xFF10B981) // text-green-500
              : const Color(0xFF9CA3AF), // text-gray-400
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
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
                  trailing: _selectedLibrary?.id == library.id 
                    ? const Icon(Icons.check_circle, color: Color(0xFF4F46E5))
                    : null,
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

  /// 构建底部快捷操作
  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // 对战记录按钮
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DuelHistoryScreen(),
                  ),
                );
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 图标
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.history,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '对战记录',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 排行榜按钮
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DuelRankingScreen(),
                  ),
                );
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA855F7), Color(0xFFDB2777)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFA855F7).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 图标
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.leaderboard,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '对战排行榜',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 匹配中对话框
class _MatchingDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  
  const _MatchingDialog({
    Key? key, 
    this.title = '正在匹配对手...',
    this.subtitle = '请稍候片刻',
  }) : super(key: key);

  @override
  State<_MatchingDialog> createState() => _MatchingDialogState();
}

class _MatchingDialogState extends State<_MatchingDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  int _dots = 0;
  Timer? _dotsTimer;
  
  @override
  void initState() {
    super.initState();
    // 初始化动画控制器
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    
    // 启动动画
    _controller.forward();
    
    // 创建动态点的定时器
    _dotsTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          _dots = (_dots + 1) % 4;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _dotsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dotsText = '';
    for (int i = 0; i < _dots; i++) {
      dotsText += '.';
    }
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
    return AlertDialog(
          content: FadeTransition(
            opacity: _opacityAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
                  // 旋转的进度指示器
                  RotationTransition(
                    turns: _controller..repeat(),
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(8.0),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                        strokeWidth: 3,
                      ),
                    ),
                  ),
          const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
                      ),
                      // 动态显示点
                      SizedBox(
                        width: 24,
                        child: Text(
                          dotsText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
          ),
          const SizedBox(height: 8),
          Text(
                    widget.subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
        ],
              ),
            ),
          ),
        );
      },
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
    _timer = null; // 确保计时器引用被清除
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  void _startCountdown() {
    if (_isDisposed || !mounted) return; // 增加mounted检查
    
    setState(() {
      _isWaiting = true;
      _countdown = 60;
    });
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed || !mounted) { // 增加mounted检查
        timer.cancel();
        return;
      }
      
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        if (mounted) { // 增加对mounted的检查
          _resetForm();
        }
      }
    });
    
    // 模拟匹配成功，2秒后返回结果
    Future.delayed(const Duration(seconds: 2), () {
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

/// 好友PK对话框 - 显示分享给微信好友选项和倒计时
class _FriendDuelDialog extends StatefulWidget {
  final VoidCallback onShareToWechat; // 分享到微信的回调
  
  const _FriendDuelDialog({
    Key? key,
    required this.onShareToWechat,
  }) : super(key: key);

  @override
  State<_FriendDuelDialog> createState() => _FriendDuelDialogState();
}

class _FriendDuelDialogState extends State<_FriendDuelDialog> {
  bool _isShared = false; // 是否已分享
  int _countdown = 30; // 倒计时30秒
  Timer? _timer; // 倒计时定时器
  bool _isDisposed = false; // 是否已销毁
  
  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
  
  /// 开始倒计时
  void _startCountdown() {
    if (_isDisposed || !mounted) return;
    
    setState(() {
      _isShared = true;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed || !mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
          _timer = null;
          // 倒计时结束，可以在这里处理超时逻辑
          if (mounted && context.mounted) {
            Navigator.pop(context); // 关闭对话框
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('好友未接受对战邀请，请重试')),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isShared ? '等待好友接受' : '邀请好友PK',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isShared) ...[
            // 未分享状态 - 显示分享说明
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '邀请好友进行词汇PK，看看谁是真正的单词王！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 分享按钮
            ElevatedButton.icon(
              onPressed: () {
                widget.onShareToWechat();
                _startCountdown();
              },
              icon: const Icon(Icons.wechat, color: Colors.white),
              label: const Text('分享给微信好友'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                backgroundColor: const Color(0xFF07C160), // 微信绿色
              ),
            ),
          ] else ...[
            // 已分享状态 - 显示倒计时
            const SizedBox(height: 16),
            GradientBackground(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: 8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      '已发送邀请',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '等待好友接受 $_countdown 秒',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: const Color(0xFFE5E7EB),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _countdown / 30, // 30秒倒计时的进度
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.5),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 分享说明
            const Text(
              '请确保好友已安装本应用，并点击您分享的链接',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
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
      ],
    );
  }
}

/// 对战模式枚举
enum DuelMode {
  random, // 随机匹配
  friend, // 好友对决
  faceToFace, // 当面PK
}

/// 对战房间对话框 - 显示匹配成功后的用户和对手信息，允许房主开始对战
class _DuelRoomDialog extends StatelessWidget {
  final User opponent; // 对手信息
  final VoidCallback onStartDuel; // 开始对战回调
  final bool isHost = true; // 是否为房主（简化版，默认为房主）
  
  const _DuelRoomDialog({
    Key? key,
    required this.opponent,
    required this.onStartDuel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取当前用户信息
    final currentUser = MockData.getCurrentUser();
    
    return AlertDialog(
      title: const Text('匹配成功'),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '已找到对手，准备好开始对战了吗？',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // 对战双方展示
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 当前用户
                Column(
                  children: [
                    Container(
                      width: 64, 
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF), // bg-indigo-100
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          currentUser.initials,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentUser.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      '(你)',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                
                // VS图标
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'VS',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // 对手
                Column(
                  children: [
                    Container(
                      width: 64, 
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF2F8), // 浅粉色背景
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: AppTheme.secondaryColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          opponent.initials,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      opponent.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFBBF24), // text-yellow-400
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Lv.${opponent.level}',
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 对战设置信息
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSettingItem(Icons.library_books, '词库', '四级核心词汇'),
                  _buildSettingItem(Icons.format_list_numbered, '题目', '10题'),
                  _buildSettingItem(Icons.timer, '时限', '15秒/题'),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // 取消匹配，返回到对战设置界面
          },
          child: const Text('取消'),
        ),
        if (isHost) // 如果是房主，显示开始对战按钮
          ElevatedButton(
            onPressed: onStartDuel,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('开始对战'),
          ),
        if (!isHost) // 如果不是房主，显示等待提示
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '等待房主开始...',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
  
  // 构建设置项
  Widget _buildSettingItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.textSecondaryColor,
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
} 