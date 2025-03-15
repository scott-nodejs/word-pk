import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// 好友列表页面
class FriendsScreen extends StatefulWidget {
  /// 构造函数
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  /// 搜索控制器
  final TextEditingController _searchController = TextEditingController();
  
  /// 示例好友数据
  final List<Map<String, dynamic>> _friends = [
    {
      'id': '1',
      'name': 'Amy Liu',
      'initials': 'AL',
      'avatarColor': Colors.blue,
      'level': 6,
      'lastActive': '今天',
      'group': 'A'
    },
    {
      'id': '2',
      'name': 'Alex Wang',
      'initials': 'AW',
      'avatarColor': Colors.green,
      'level': 8,
      'lastActive': '昨天',
      'group': 'A'
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'initials': 'MJ',
      'avatarColor': Colors.purple,
      'level': 7,
      'lastActive': '3天前',
      'group': 'M'
    },
    {
      'id': '4',
      'name': 'Sarah Kim',
      'initials': 'SK',
      'avatarColor': Colors.amber,
      'level': 9,
      'lastActive': '今天',
      'group': 'S'
    },
  ];

  /// 分组好友
  Map<String, List<Map<String, dynamic>>> _groupedFriends = {};

  @override
  void initState() {
    super.initState();
    _groupFriends();
  }

  /// 按字母分组好友
  void _groupFriends() {
    _groupedFriends = {};
    for (var friend in _friends) {
      final group = friend['group'];
      if (!_groupedFriends.containsKey(group)) {
        _groupedFriends[group] = [];
      }
      _groupedFriends[group]!.add(friend);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 顶部状态栏占位
          SizedBox(height: statusBarHeight),
          
          // 顶部导航
          _buildTopBar(context),
          
          // 搜索框
          _buildSearchBar(),
          
          // 好友申请提示
          _buildFriendRequests(),
          
          // 好友列表（可滚动）
          Expanded(
            child: _buildFriendsList(),
          ),
          
          // 底部导航
          _buildBottomNav(),
        ],
      ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF3F4F6),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: const Color(0xFF6B7280),
              ),
              const SizedBox(width: 12),
              const Text(
                '我的好友',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/add-friend');
            },
          ),
        ],
      ),
    );
  }

  /// 构建搜索栏
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '搜索好友',
            hintStyle: TextStyle(
              color: Color(0xFF9CA3AF),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFF9CA3AF),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }

  /// 构建好友申请提示
  Widget _buildFriendRequests() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          // 导航到好友申请页面
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person_add,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '好友申请',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '2个待处理的好友申请',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF9CA3AF),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建好友列表
  Widget _buildFriendsList() {
    final groups = _groupedFriends.keys.toList()..sort();
    
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80), // 底部留出空间，避免被底部导航遮挡
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final friends = _groupedFriends[group]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分组标题
            _buildGroupHeader(group),
            
            // 好友列表
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: friends.length,
              itemBuilder: (context, i) => _buildFriendItem(friends[i]),
            ),
            
            // 组间间距
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  /// 构建分组标题
  Widget _buildGroupHeader(String group) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            group,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFFE5E7EB),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建好友项目
  Widget _buildFriendItem(Map<String, dynamic> friend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // 头像
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: friend['avatarColor'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      friend['initials'],
                      style: TextStyle(
                        color: friend['avatarColor'],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // 好友信息
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // 等级标签
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Lv.${friend['level']}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // 最近学习时间
                        Text(
                          '最近学习：${friend['lastActive']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            // 聊天按钮
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppTheme.primaryColor,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  // 打开聊天
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建底部导航
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFF3F4F6),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, '首页', false),
          _buildNavItem(Icons.book_outlined, '词库', false),
          _buildNavItem(Icons.people_outline, '社区', true),
          _buildNavItem(Icons.person_outline, '我的', false),
        ],
      ),
    );
  }
  
  /// 构建导航项
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final color = isActive ? AppTheme.primaryColor : const Color(0xFF9CA3AF);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }
} 